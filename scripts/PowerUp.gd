extends CharacterBody2D

const GRAVITY = 3900

const SPEED = 300

const Direction = {
	LEFT = -1,
	RIGHT = 1
}

var direction = Direction.RIGHT

func _physics_process(delta):
	if is_on_wall():
		direction *= -1
	
	velocity.x = SPEED * direction
	velocity.y += GRAVITY * delta
	move_and_slide()
