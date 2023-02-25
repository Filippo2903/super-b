extends KinematicBody2D

export var speed = 75 # How fast the player will move (pixels/sec).
var velocity = Vector2.ZERO # The player's movement vector.
const GRAVITY = 200
const JUMP_SPEED = -800
var on_ground = false
var tempGravity
var i = 10
var cicli = 0

func _ready():
	pass

func _physics_process(delta):
	cicli +=1
	if velocity.y==0:
		i=10
		cicli = 0
	velocity.y += GRAVITY * delta * i
	i = cicli * 0.01 +10
	print (velocity)
	#velocity = move_and_slide(velocity, Vector2.UP)
	
	
func jump():
	if on_ground:
		velocity.y = JUMP_SPEED

func _input(event):
	if event.is_action_pressed("ui_select"):
		jump()
	elif event.is_action_released("ui_select") and velocity.y < 0:
		velocity.y = 0
	
		

func animation():
	if velocity.length() < 10 and is_on_floor():
		$AnimatedSprite.animation = "fermo"
		$AnimatedSprite.stop()
	
	else:
		if not on_ground:
			$AnimatedSprite.play("salta")
		
		elif velocity.x != 0:
			$AnimatedSprite.play("cammina")
			# See the note below about boolean assignment.
		if velocity.x != 0:
			$AnimatedSprite.flip_h = velocity.x < 0
		

func _process(delta):
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed
	
	velocity = move_and_slide(velocity, Vector2.UP)
	on_ground = is_on_floor()
	
	animation()
	
	velocity.x = lerp (velocity.x,0,0.2)

