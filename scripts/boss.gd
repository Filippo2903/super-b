extends CharacterBody2D

const GRAVITY = 3900
const SPEED = 400

const Attack = {
	SPELL = 1,
	ROLLING = 0
}

const Status = {
	STAGE1 = 0,
	STAGE2 = 1,
	STAGE3 = 2
}

@onready var animation = $AnimatedSprite2D

var status = Status.STAGE1
var speed = SPEED
var direction = -1
var attack

var flip_count = 0

func _ready():
	set_up_direction(Vector2.UP)
	attack = Attack.ROLLING

func hit():
	if status == Status.STAGE3:
		queue_free()
	
	status += 1
	speed = SPEED + status * 300

func flip():
	flip_count += 1
	direction *= -1
	animation.scale.x *= -1

func animate():
	if attack == Attack.ROLLING:
		animation.play("roll")
	else:
		animation.play("spell")

func move(delta, speed):
	if is_on_wall():
		flip()
	
	velocity.x = speed * direction
	velocity.y += GRAVITY * delta
	move_and_slide()

func spell():
	attack = Attack.ROLLING

func _process(_delta):
	animate()

func _physics_process(delta):
	#if flip_count > 3:
	#	attack = Attack.SPELL
	#	spell()
	#	flip_count = 0
	#if attack == Attack.ROLLING:
		move(delta, speed)

func _on_edge(body):
	flip()

func _on_side_collision(body):
	body.hit()

func _on_top_collision(body):
	if body.has_method("rebound"):
		body.rebound(900)
	hit()
