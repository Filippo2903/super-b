extends AnimatedSprite2D

const Level = {
	START = 0,
	ONE = 1,
	TWO = 2,
	BOSS = 3
}

const SPEED = 1000

var current_level = Level.START
var level_selected = Level.START
var goal = position.x

var distance = [1000, 1020, 1540, 1860]
var livelli = ["", "res://scenes/Level1.tscn", "res://scenes/Level2.tscn", "res://scenes/BossFight.tscn"]

func animate():
	flip_h = position.x > goal
	
	if position.x != goal:
		play("walk")
	else:
		current_level = level_selected
		animation = "steady"
		stop()

func move(delta):
	if Input.is_action_just_pressed("ui_right") and current_level == level_selected and level_selected < Level.BOSS:
		level_selected += 1
		goal = position.x + distance[level_selected]
	
	if Input.is_action_just_pressed("ui_left") and current_level == level_selected and level_selected > Level.START:
		level_selected += -1
		goal = position.x - distance[current_level]
	
	if Input.is_action_just_pressed("ui_accept") and current_level == level_selected and level_selected > Level.START:
		get_tree().change_scene_to_file(livelli[level_selected])
	
	position.x = move_toward(position.x, goal, delta * SPEED)

func _process(delta):
	move(delta)
	animate()
