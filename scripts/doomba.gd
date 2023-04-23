extends CharacterBody2D

const GRAVITY = 3900

const WALK_SPEED = 150

const Direction = {
	LEFT = -1,
	RIGHT = 1
}

const Status = {
	WALKING = 1,
	DEAD = 0
}

@onready var animation = $AnimatedSprite2D

var status = Status.WALKING
var direction = Direction.LEFT

func _ready():
	animation.play("walk")
	set_up_direction(Vector2.UP)
	status = Status.WALKING

func _on_SideCollision_body_entered(body):
	body.hit()

func _on_TopCollision_body_entered(body):
	body.rebound = true
	hit()

func hit():
	status = Status.DEAD

func free():
	set_physics_process(false)
	
	animation.play("explosion")
	while(animation.is_playing()):
		continue
	
	queue_free()

func move(delta):
	if is_on_wall():
		direction *= -1
	
	velocity.x = WALK_SPEED * direction
	velocity.y += GRAVITY * delta
	move_and_slide()

func _physics_process(delta):
	move(delta)
