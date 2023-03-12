extends CharacterBody2D

const GRAVITY = 3900
const SPEED = 50000
const JUMP_SPEED = 600

var direction
var jumping = false
var jump_duration = 0

func _ready():
	set_up_direction(Vector2.UP)

#func _on_mob_detected(body):
	#body.kill()
	#queue_free()

func jump(delta):
	if is_on_floor():
		jumping = true
	
	if jumping:
		jump_duration += delta
		velocity.y = -JUMP_SPEED
		if jump_duration > 2 * delta:
			jump_duration = 0
			jumping = false
	
	move_and_slide()

func _physics_process(delta):
	velocity.y += GRAVITY * delta

func _process(delta):
	velocity.x = direction * SPEED * delta
	$Sprite2D.rotate(direction)
	jump(delta)
	
	if is_on_wall(): 
		if $MobDetecter.has_overlapping_bodies():
			print("dsad")
			var overlapping_bodies = $MobDetecter.get_overlapping_bodies()
			for body in overlapping_bodies:
				body.kill()
				print(body)
		queue_free()
