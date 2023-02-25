extends KinematicBody2D

const GRAVITY = 3900

const SPEED = 75
const JUMP_SPEED = 1420

var velocity
var cycle

var t


func animate():
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	if velocity.length() < 10 and is_on_floor():
		$AnimatedSprite.animation = "fermo"
		$AnimatedSprite.stop()
	
	elif not is_on_floor():
		$AnimatedSprite.play("salta")
	
	elif velocity.x != 0:
		$AnimatedSprite.play("cammina")

func move():
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x += -SPEED
	if Input.is_action_pressed("ui_down"):
		velocity.y += SPEED
		
	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			velocity.y = -JUMP_SPEED # -3.189 * (t*t) * 8.205 * t - 3.961
	elif Input.is_action_just_released("ui_select") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0, 0.6)
	
	if Input.is_key_pressed(KEY_R):
		position.x = 650
		position.y = 320
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.2)


func _ready():
	cycle = 0
	velocity = Vector2.ZERO

func _physics_process(delta):
	if velocity.y == 0:
		cycle = 0
	cycle += 1
	
	t = cycle * delta
	velocity.y += GRAVITY * delta # (cycle * 0.01 + 10)

func _process(delta):
	move()
	animate()
