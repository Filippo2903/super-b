extends "res://scripts/mob.gd"

const WALK_SPEED = 150

const Status = {
	WALKING = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D

var status = Status.WALKING

func _ready():
	animation.play("walk")
	set_up_direction(Vector2.UP)
	status = Status.WALKING

func _on_SideCollision_body_entered(body):
	body.rebound_speed = 800
	body.hit()

func _on_TopCollision_body_entered(body):
	body.rebound = true
	hit()

func hit():
	status = Status.DEAD

func free():
	queue_free()

func _physics_process(delta):
	move(delta, WALK_SPEED)
