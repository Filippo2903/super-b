extends KinematicBody2D

const GRAVITY = 3900

const WALK_SPEED = 500
const GROUND_POUND_SPEED = 1300
const JUMP_SPEED = 1500

const Direction = {
	STEADY = 0,
	LEFT = -1,
	RIGHT = 1
}

const Status = {
	DEAD = 0,
	SMALL = 1,
	BIG = 2,
	POWER_UP = 3
}

onready var animation = $AnimatedSprite
onready var hitbox = $CollisionShape2D

var status = Status.SMALL
var direction = Direction.STEADY
var velocity = Vector2.ZERO

var jumping = false
var ground_pound = false
var ground_pound_pause = 0


func animate():
	if velocity.x != 0:
		animation.flip_h = velocity.x < 0
	
	if ground_pound:
		animation.animation = "ground_pound"
		animation.stop()
	
	elif jumping:
		animation.animation = "jump"
		animation.stop()
	
	elif abs(velocity.x) > 60:
		animation.play("walk")
	
	else:
		animation.animation = "steady"
		animation.stop()

func move(delta):
	direction = Direction.STEADY
	
	if is_on_floor():
		animation.set_position(Vector2(hitbox.position.x, hitbox.position.y))
		jumping = false
		ground_pound = false
		ground_pound_pause = 0
		
	if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("shift")) and not is_on_floor():
		hitbox.set_position(Vector2(hitbox.position.x, hitbox.position.y - 20))
		ground_pound = true
	
	if ground_pound:
		# wait some time before going down
		ground_pound_pause += delta
		
		if ground_pound_pause < 15 * delta:
			animation.rotate(0.447)
			return
		animation.rotation = 0 
		velocity.x = 0
		velocity.y = GROUND_POUND_SPEED
		velocity = move_and_slide(velocity, Vector2.UP)
		return
	
	if Input.is_action_pressed("ui_right"):
		direction += Direction.RIGHT
	if Input.is_action_pressed("ui_left"):
		direction += Direction.LEFT
	
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		jumping = true
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_released("ui_select") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0, 0.4)
	
	velocity.x = lerp(velocity.x, WALK_SPEED * direction, 0.1)
	velocity = move_and_slide(velocity, Vector2.UP)

func status_switch():
	print("cazz")
	match(status):
		Status.POWER_UP:
			scale.y = 2
			return
		Status.BIG:
			scale.y = 2
			return
		Status.SMALL:
			scale.y = 1
			return
		Status.DEAD:
			print("caz1sdz")
			respawn()

func respawn():
	position.x = 500
	position.y = -500
	scale.y = 1
	

func status_down():
	
	if status > Status.DEAD:
		status -= 1
	status_switch()
	
	
func status_up():
	if status < Status.POWER_UP:
		status +=1
	status_switch()

func debug_reset():
	if Input.is_key_pressed(KEY_R):
		respawn()


func _ready():
	# DEBUG
	status = Status.BIG
	
	status_switch()

func _physics_process(delta):
	velocity.y += GRAVITY * delta

func _process(delta):
	move(delta)
	animate()
	debug_reset()
