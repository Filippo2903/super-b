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
	NORMAL = 2,
	STEADY = 1,
	ROLLING = 0
}

@onready var animation = $AnimatedSprite2D

var status = Status.NORMAL
var direction = Direction.LEFT

var speed = Speed.WALK


func _ready():
	animation.play("walk")
	status = Status.NORMAL
	change_status()

func _on_SideCollision_body_entered(body):
	if body.name != "Player":
		return
	
	if status != Status.STEADY:
		body.hit()
	else:
		if body.position.x < position.x:
			direction = 1
		else:
			direction = -1
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
			
func hit():
	if status == Status.ROLLING:
		status += 1
	else:
		status -= 1
	
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
