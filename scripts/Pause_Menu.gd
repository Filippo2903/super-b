extends CanvasLayer

@onready var Pause_Controller = "../PauseController"
@onready var fullscreen_check_button: CheckButton = $%FullscreenCheckButton
@onready var vsync_check_button: CheckButton = $%VSyncCheckButton

var config = ConfigFile.new()



func save_options():
	config.set_value("Options", "fullscreen", fullscreen_check_button.button_pressed)

	config.set_value("Options", "vsync", vsync_check_button.button_pressed)
	
	config.save("res://options.cfg")

func load_options():
	var err = config.load("res://options.cfg")
	
	var fullscreen = config.get_value("Options", "fullscreen", false)
	var vsync = config.get_value("Options", "vsync", false)

	fullscreen_check_button.button_pressed = fullscreen
	
	vsync_check_button.set_pressed_no_signal(vsync)
	vsync_check_button.emit_signal("toggled", vsync)
	
func _ready():
	load_options()
	
	
func _on_resume_pressed():
	save_options()
	get_node(Pause_Controller).resume()
	get_tree().set_deferred("paused", false)

func _on_fullscreen_check_button_toggled(button_pressed):
	if button_pressed:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_v_sync_check_button_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_menu_pressed():
	get_node(Pause_Controller).resume()
	get_tree().change_scene_to_file("res://scenes/Choose_Level_Menu.tscn")


func _on_exit_pressed():
	get_node(Pause_Controller).resume()
	get_tree().change_scene_to_file("res://scenes/Main_Menu.tscn")
