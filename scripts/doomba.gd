extends "res://scripts/mob.gd"

const WALK_SPEED = 150

const Status = {
	WALKING = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D

var status = Status.WALKING

func _ready():
	set_up_direction(Vector2.UP)
	animation.play("walk")

func _on_SideCollision_body_entered(body):
	body.hit()

func _on_TopCollision_body_entered(body):
	body.rebound_speed = 800
	body.rebound = true
	hit()

func hit():
	status = Status.DEAD

func free():
	queue_free()

func flip():
	direction *= -1

func _physics_process(delta):
	if is_on_wall():
		flip()
	move(delta, WALK_SPEED)
