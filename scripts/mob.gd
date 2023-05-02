extends CharacterBody2D

const GRAVITY = 3900

const Direction = {
	LEFT = -1,
	RIGHT = 1
}

var direction = Direction.LEFT

func flip():
	direction *= -1

func hit():
	pass

func free():
	queue_free()

func move(delta, speed : int):
	if is_on_wall():
		flip()
	
	velocity.x = speed * direction
	velocity.y += GRAVITY * delta
	move_and_slide()
