extends CharacterBody2D

const SPEED = 8

const Status = {
	WALKING = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D

var direction = 1
var status = Status.WALKING

var path

func _ready():
	set_up_direction(Vector2.UP)
	path = get_parent()
	animation.play("fly")

func _on_SideCollision_body_entered(body):
	body.hit()

func _on_TopCollision_body_entered(body):
	if body.has_method("rebound"):
		body.rebound(900)
	hit()

func hit():
	status = Status.DEAD
	queue_free()

func flip():
	direction *= -1

func _physics_process(delta):
	path.progress += SPEED
