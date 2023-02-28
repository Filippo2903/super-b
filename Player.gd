extends KinematicBody2D

const GRAVITY = 3900

<<<<<<< HEAD
const WALK_SPEED = 500
=======
const WALK_SPEED = 700
const RUN_SPEED = 1000
>>>>>>> da9e76be576892de50587eb8284a8d313b10d55b
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

<<<<<<< HEAD
var jumping = false
var ground_pound = false

var ground_pound_pause = 0

var n = 0

=======
var moving_speed = WALK_SPEED

var jumping = false
var ground_pound = false

var sleep = false

var n = 0


>>>>>>> da9e76be576892de50587eb8284a8d313b10d55b
func animate():
	if velocity.x != 0:
		animation.flip_h = velocity.x < 0
	
	if ground_pound:
		animation.animation = "ground_pound"
		animation.stop()
	
	elif jumping:
		animation.animation = "jump"
		animation.stop()
	
	elif velocity.length() > 0.5:
<<<<<<< HEAD
		animation.play("walk")
=======
		if abs(velocity.x) > WALK_SPEED:
			animation.play("run")
		else:
			animation.play("walk")
>>>>>>> da9e76be576892de50587eb8284a8d313b10d55b
	
	else:
		animation.animation = "steady"
		animation.stop()

<<<<<<< HEAD
func move(delta):
	direction = Direction.STEADY
=======
func sleep(sec):
	if n < sec:
		sleep = true
	n += 1

func move():
	direction = Direction.STEADY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	sleep(3)
>>>>>>> da9e76be576892de50587eb8284a8d313b10d55b
	
	if is_on_floor():
		animation.set_position(Vector2(hitbox.position.x, hitbox.position.y))
		jumping = false
		ground_pound = false
<<<<<<< HEAD
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
=======
	
	if Input.is_action_just_pressed("shift"):
		if is_on_floor():
			moving_speed = RUN_SPEED
	elif int(velocity.x) == 0:
		moving_speed = WALK_SPEED
>>>>>>> da9e76be576892de50587eb8284a8d313b10d55b
	
	if Input.is_action_pressed("ui_right"):
		direction += Direction.RIGHT
	if Input.is_action_pressed("ui_left"):
		direction += Direction.LEFT
	
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		jumping = true
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_released("ui_select") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0, 0.4)
	
<<<<<<< HEAD
	velocity.x = lerp(velocity.x, WALK_SPEED * direction, 0.1)
	velocity = move_and_slide(velocity, Vector2.UP)
=======
	if Input.is_action_just_pressed("ui_down") and not is_on_floor():
		hitbox.set_position(Vector2(hitbox.position.x, hitbox.position.y - 20))
		ground_pound = true
	
	if ground_pound:
		# wait some time before going down
		velocity.x = 0
		velocity.y = GROUND_POUND_SPEED
		return
	
	velocity.x = lerp(velocity.x, moving_speed * direction, 0.1)

>>>>>>> da9e76be576892de50587eb8284a8d313b10d55b

func debug_reset():
	if Input.is_key_pressed(KEY_R):
		position.x = 650
		position.y = 320


func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta

func _process(delta):
<<<<<<< HEAD
	move(delta)
=======
	if sleep:
		return
	move()
>>>>>>> da9e76be576892de50587eb8284a8d313b10d55b
	animate()
	debug_reset()
