extends KinematicBody2D

const GRAVITY = 3900

const WALK_SPEED = 700
const RUN_SPEED = 1000
const GROUND_POUND_SPEED = 1500
const JUMP_SPEED = 1450

const Direction = {
	STEADY = 0,
	LEFT = -1,
	RIGHT = 1
}

var velocity = Vector2.ZERO
var direction = Direction.STEADY

var moving_speed = WALK_SPEED

var jumping = false
var ground_pound = false


func animate():
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	if ground_pound:
		$AnimatedSprite.play("ground_pound")
		
	elif jumping:
		$AnimatedSprite.animation = "jump"
		$AnimatedSprite.stop()
	
	elif velocity.length() > 0.5:
		if moving_speed <= WALK_SPEED:
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("run")
	
	else:
		$AnimatedSprite.animation = "steady"
		$AnimatedSprite.stop()

func move():
	direction = Direction.STEADY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		jumping = false
		ground_pound = false
	
	if Input.is_action_just_pressed("shift"):
		if is_on_floor():
			moving_speed = RUN_SPEED
	elif int(velocity.x) == 0:
		moving_speed = WALK_SPEED
	
	if Input.is_action_pressed("ui_right"):
		direction += Direction.RIGHT
	if Input.is_action_pressed("ui_left"):
		direction += Direction.LEFT
	
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		jumping = true
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_released("ui_select") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0, 0.4)
	
	if Input.is_action_just_pressed("ui_down") and not is_on_floor():
		ground_pound = true
	
	if ground_pound:
		velocity.x = 0
		velocity.y = GROUND_POUND_SPEED
		return
	
	velocity.x = lerp(velocity.x, moving_speed * direction, 0.3)
	
	if Input.is_key_pressed(KEY_R):
		position.x = 650
		position.y = 320


func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta

func _process(delta):
	move()
	animate()
