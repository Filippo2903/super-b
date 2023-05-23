extends CharacterBody2D

const GRAVITY = 3900
const SPEED = 800

const Attack = {
	SPELL = 1,
	ROLLING = 0
}

const Status = {
	STAGE1 = 0,
	STAGE2 = 1,
	STAGE3 = 2
}

const MagicSpellPath = preload('res://scenes/MagicSpell.tscn')

@onready var animation = $AnimatedSprite2D

var status = Status.STAGE1
var speed = SPEED
var direction = -1
var attack

var not_spell = true
var spell_pause = 0
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

func move(delta):
	if is_on_wall():
		flip()
	
	velocity.x = speed * direction
	velocity.y += GRAVITY * delta
	move_and_slide()

func spell():
	var positon_offset = Vector2(32 * direction, 0)
	var magic_spell = MagicSpellPath.instantiate()
	get_parent().add_child(magic_spell)
	magic_spell.position = position + positon_offset

func _process(_delta):
	animate()

func _physics_process(delta):
	if flip_count > 2:
		attack = Attack.SPELL
		flip_count = 0
	if attack == Attack.SPELL:
		if spell_pause < 200 * delta:
			if spell_pause > 100 * delta and not_spell:
				spell()
				not_spell = false
			spell_pause += delta
			return
		not_spell = true
		spell_pause = 0
		attack = Attack.ROLLING
	if attack == Attack.ROLLING:
		move(delta)

func _on_edge(_body):
	flip()

func _on_side_collision(body):
	body.hit()

func _on_top_collision(body):
	if body.has_method("rebound"):
		body.rebound(900)
	hit()
