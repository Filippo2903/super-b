extends CharacterBody2D

var direction 
const speed = 1000
var collided_body
	
func _ready():
	pass # Replace with function body.

func _process(delta):
	velocity.x = direction * speed * delta
	collided_body = move_and_collide(velocity)
	if collided_body:
		if collided_body.get_collider().is_class("CharacterBody2D"):
			collided_body.get_collider().kill()
		queue_free()


