extends "res://scripts/mob.gd"

const Speed = {
	STEADY = 0,
	WALK = 150,
	ROLL = 800
}

const Status = {
	WALKING = 3,
	STEADY = 2,
	ROLLING = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D

var status = Status.WALKING

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
	if body.has_method("rebound"):
		body.rebound(800)
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

func flip():
	direction *= -1
	animation.scale.x *= -1

func animate():
	if status == Status.WALKING:
		animation.play("walk")
	else:
		animation.play("roll")

func _process(_delta):
	animate()

func _physics_process(delta):
	if is_on_wall():
		flip()
	move(delta, speed)

func _on_edge(body):
	if status == Status.WALKING:
		flip()
