extends Node

const menuPath = preload('res://scenes/Pause_Menu.tscn')

func _process(delta):
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
	get_node("../Pause_Menu").save_options()
	get_node("../Pause_Menu").queue_free()
	get_tree().set_deferred("paused", false)
