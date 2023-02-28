extends KinematicBody2D

const SPEED = 150

const Direction = {
	STEADY = 0,
	LEFT = -1,
	RIGHT = 1
}
var velocity = Vector2.ZERO
var direction = Direction.LEFT

onready var animation = $AnimatedSprite


func _ready():
	animation.play("walk")

func _process(delta):
	
	if is_on_wall():
		direction *= -1
		animation.flip_h = direction == 1
		
	velocity.x = SPEED * direction
	velocity = move_and_slide(velocity, Vector2.UP)
