extends CharacterBody2D

#const GRAVITY = 3900

const Speed = {
	STEADY = 0,
	WALK = 150,
	ROLL = 800
}

const Direction = {
	LEFT = -1,
	RIGHT = 1
}

const Status = {
	NORMAL = 3,
	STEADY = 2,
	ROLLING = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D

var status = Status.NORMAL
var direction = Direction.LEFT

var speed = Speed.WALK

var collided_body

func _ready():
	animation.play("walk")
	status = Status.NORMAL
	change_status()

func _on_SideCollision_body_entered(body):
	
	if status != Status.STEADY:
		body.hit()
	else:
		hit()
	
func _on_TopCollision_body_entered(body):
	body.rebound = true
	hit()
	
func change_status():
	match status:
		Status.NORMAL:
			speed = Speed.WALK
		Status.STEADY:
			speed = Speed.STEADY
		Status.ROLLING:
			speed = Speed.ROLL
		Status.DEAD:
			queue_free()
			
func hit():
	if status == Status.ROLLING:
		status += 1
	else:
		status -= 1
	$AudioStreamPlayer2D.play()
	change_status()

func kill():
	$AudioStreamPlayer2D.play()
	status = Status.DEAD
	change_status()

func animate():
	animation.flip_h = direction == 1
	if status == Status.NORMAL:
		animation.play("walk")
	else:
		animation.play("roll")

func move(delta):
	if is_on_wall():
		direction *= -1
	
	velocity.x = speed * direction
	velocity.y = 0
	set_up_direction(Vector2.UP)
	move_and_slide()

func _process(delta):
	move(delta)
	animate()
	
