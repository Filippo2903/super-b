extends CharacterBody2D

const GRAVITY = 3900

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
	WALKING = 3,
	STEADY = 2,
	ROLLING = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D

var status = Status.WALKING
var direction = Direction.LEFT

var speed = Speed.WALK

func _ready():
	set_up_direction(Vector2.UP)
	status = Status.WALKING
	set_speed()

func _on_SideCollision_body_entered(body):
	if status != Status.STEADY:
		body.hit()
	else:
		hit()

func _on_TopCollision_body_entered(body):
	body.rebound = true
	hit()

func set_speed():
	match status:
		Status.WALKING:
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
	$AudioStreamPlayer2D.play()
	set_speed()

func free():
	queue_free()

func animate():
	animation.flip_h = direction == Direction.RIGHT
	if status == Status.WALKING:
		animation.play("walk")
	else:
		animation.play("roll")

func move(delta):
	if is_on_wall():
		direction *= -1
	
	velocity.x = speed * direction
	velocity.y += GRAVITY * delta
	move_and_slide()

func _process(_delta):
	animate()

func _physics_process(delta):
	move(delta)
