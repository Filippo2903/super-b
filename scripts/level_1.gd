extends Node2D

const MARTA_DATA_PATH = preload('res://scenes/Marta.tscn')
const DOOMBA_DATA_PATH = preload('res://scenes/Doomba.tscn')

const DEAD = 0
var i = 0
var mob = [
	{ position = Vector2(1750, -32), type = DOOMBA_DATA_PATH, is_spawned = false, is_dead = false },
	{ position = Vector2(2500, -32), type = DOOMBA_DATA_PATH, is_spawned = false, is_dead = false },
	{ position = Vector2(3000, -32), type = DOOMBA_DATA_PATH, is_spawned = false, is_dead = false },
	{ position = Vector2(5000, -62), type = MARTA_DATA_PATH, is_spawned = false, is_dead = false },
	{ position = Vector2(6000, -62), type = MARTA_DATA_PATH, is_spawned = false, is_dead = false }
]

var spawned_mob = []

func spawn_mob():
	var pg_camera = get_node("Player/Camera2D").get_viewport_rect()
	pg_camera.position = get_node("Player/Camera2D").global_position - pg_camera.size / 2 + get_node("Player/Camera2D").offset
	pg_camera = pg_camera.grow_individual(500, 10000, 500, 10000)
	
	for i in range(len(mob)):
		if mob[i].is_dead:
			continue
		
		if mob[i].is_spawned and spawned_mob[i].status == DEAD:
			mob[i].is_dead = true
			mob[i].is_spawned = false
			spawned_mob[i].free()
			continue
		
		if not mob[i].is_spawned and pg_camera.has_point(mob[i].position):
			spawned_mob[i] = mob[i].type.instantiate()
			spawned_mob[i].position = mob[i].position
			get_parent().add_child(spawned_mob[i])
			mob[i].is_spawned = true
		
		elif mob[i].is_spawned and not pg_camera.has_point(spawned_mob[i].position):
			mob[i].position = spawned_mob[i].position
			spawned_mob[i].queue_free()
			mob[i].is_spawned = false

func _ready():
	spawned_mob.resize(len(mob))

func _process(_delta):
	i = i + 1
	if (_delta*i==5):
		get_tree().change_scene_to_file("res://scenes/Level_2.tscn")
	spawn_mob()
