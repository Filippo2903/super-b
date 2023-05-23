extends Node

const menuPath = preload('res://scenes/PauseMenu.tscn')

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if !get_tree().paused:
			pause()
		else:
			resume()

func pause():
	var menu = menuPath.instantiate()
	get_parent().add_child(menu)
	get_tree().set_deferred("paused", true)

func resume():
	get_node("../PauseMenu").save_options()
	get_node("../PauseMenu").queue_free()
	get_tree().set_deferred("paused", false)
