extends CharacterBody2D

const SPEED = 400

var player

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta):
	var direction = player.position - position
	velocity = direction.normalized() * SPEED
	move_and_slide()

func _on_hit(body):
	if body.has_method("hit"):
		body.hit()
		queue_free()

func _on_timer_timeout():
	queue_free()
