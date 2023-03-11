extends CharacterBody2D

const JUMP_SPEED = 1500
const GRAVITY = 3900
var direction 
const speed = 50000
var collided_body
var rebound = false
var rebound_pause = 0
const REBOUND_SPEED = 600

func _ready():
	set_up_direction(Vector2.UP)

func _on_area_2d_body_entered(body):
	body.kill()
	queue_free()

func jump(delta):
	if is_on_floor():
		rebound=true
	if rebound:
		rebound_pause += delta
		if rebound_pause < 2 * delta:
			velocity.y = -REBOUND_SPEED
		else:
			rebound = false
			rebound_pause = 0
		set_up_direction(Vector2.UP)
		move_and_slide()
		return
		
	move_and_slide()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
		
func _process(delta):
	velocity.x = direction * speed * delta
	$Sprite2D.rotate(direction)
	jump(delta)
	
	
	if is_on_wall():
		queue_free()
	



