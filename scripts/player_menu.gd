extends AnimatedSprite2D

const Direction = {
	STEADY = 0,
	LEFT = -1,
	RIGHT = 1
}
var direction = Direction.STEADY
var distance = 1000
var destinazione = 0
var speed = 1000
var direction_watching
var livello_selezionato = 0
var livelli = ["res://scenes/Level_1.tscn","res://scenes/Level_2.tscn"]


func _ready():
	pass
	

func animate():
	if position.x != destinazione:
		flip_h = direction_watching - 1
	
	if position.x != destinazione:
		play("walk")
	else:
		animation = "steady"
		stop()

func _process(delta):
	
	if position.x == destinazione:
		
		if Input.is_action_just_pressed("ui_right"):
			direction = Direction.RIGHT
			direction_watching = direction
		if Input.is_action_just_pressed("ui_left"):
			direction = Direction.LEFT
			direction_watching = direction
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file(livelli[livello_selezionato])
	
	
	if (livello_selezionato + direction >= 0) and (livello_selezionato + direction <= livelli.size()):
		print(livello_selezionato)
		livello_selezionato += direction
		destinazione += direction * distance
		position.x = move_toward(position.x, destinazione, delta * speed)
	animate()
	direction = Direction.STEADY
