extends KinematicBody2D

const GRAVITY = 3900

const WALK_SPEED = 650
const JUMP_SPEED = 1500
const GROUND_POUND_SPEED = 1300
const REBOUND_SPEED = 800

const Direction = {
	STEADY = 0,
	LEFT = -1,
	RIGHT = 1
}

const Status = {
	POWER_UP = 3,
	NORMAL = 2,
	SMALL = 1,
	DEAD = 0
}

onready var animation = $AnimatedSprite
onready var hitbox = $CollisionShape2D

var status
var direction = Direction.STEADY
var velocity = Vector2.ZERO

var jumping = false
var crouch = false
var ground_pound = false
var ground_pound_pause = 0
var rebound = false
var rebound_pause = 0

var just_hitted=0

func hit():
	just_hitted=true
	status_down()
	
func animate():
	if velocity.x != 0:
		animation.flip_h = velocity.x < 0
	
	if crouch:
		animation.animation = "crouch"
		animation.stop()
	
	elif ground_pound:
		if is_on_floor():
			animation.animation = "crouch"
			animation.stop()
			return
		animation.animation = "ground_pound"
		animation.stop()
		
		
	elif not is_on_floor():
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
		if ground_pound and not (Input.is_action_pressed("ui_down") or Input.is_action_pressed("shift")):
			if status == 1:
				scale.y = status
			if status >= 2:
				scale.y = 2
			position.y-=32
			ground_pound = false
			ground_pound_pause = 0
			hitbox.scale.y = 1
		jumping = false
		
	if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("shift")) and not is_on_floor():
		if status == 1:
				scale = Vector2(1,1)
		if status >= 2:
			scale = Vector2(1,1)
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
	
	
	if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("shift"))  and status > 1:
		position.y +=32
		crouch = true
		
		
	if crouch:
		if (Input.is_action_just_released("ui_down") or Input.is_action_just_released("shift")) or just_hitted:
			crouch = false
			if status == 1:
				scale.y = status
			if status >= 2:
				scale.y = 2
			position.y -=32
			return
		scale.y = 1
		velocity.x = lerp(velocity.x, 0, 0.1)
		print(velocity)
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
	
	if rebound:
		rebound_pause += delta
		if rebound_pause < 2 * delta:
			velocity.x = 0
			velocity.y = -REBOUND_SPEED
		else:
			rebound = false
			rebound_pause = 0
		move_and_slide(velocity, Vector2.UP)
		return
		
	velocity = move_and_slide(velocity, Vector2.UP)


func status_down():
	if status > Status.DEAD:
		status -= 1
	match_status()
	
func status_up():
	if status < Status.POWER_UP:
		status += 1
	match_status()

func match_status():
	if scale.y == 1:
		position.y -= 32
	match status:
		Status.POWER_UP:
			scale.y = 2
		Status.NORMAL:
			scale.y = 2
		Status.SMALL:
			scale.y = 1
		Status.DEAD:
			respawn()

func respawn():
	position.x = 500
	position.y = -500
	status = Status.SMALL
	#scale.y = 1

func _ready():
	# DEBUG
	status = Status.NORMAL
	match_status()

func _physics_process(delta):
	velocity.y += GRAVITY * delta

func _process(delta):
	move(delta)
	animate()
	debug_reset()

func debug_reset():
	if Input.is_key_pressed(KEY_R):
		status = Status.NORMAL
		match_status()
		respawn()
