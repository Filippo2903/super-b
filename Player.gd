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

onready var animation = $AnimatedSprite
onready var hitbox = $CollisionShape2D

var velocity = Vector2.ZERO
var direction = Direction.STEADY

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

func die():
	position.x = 500
	position.y = -500
	
func collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name != "Marta":
			return

func debug_reset():
	if Input.is_key_pressed(KEY_R):
		position.x = 500
		position.y = -500


func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta

func _process(delta):
	move(delta)
	animate()
	collision()
	debug_reset()
