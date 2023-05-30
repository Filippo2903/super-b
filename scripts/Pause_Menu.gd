extends CanvasLayer

@onready var PauseController = "../PauseController"
@onready var FullscreenCheckButton: CheckButton = $%FullscreenCheckButton
@onready var VsyncCheckButton: CheckButton = $%VSyncCheckButton

var config = ConfigFile.new()

func save_options():
	config.set_value("Options", "fullscreen", FullscreenCheckButton.button_pressed)
	config.set_value("Options", "vsync", VsyncCheckButton.button_pressed)
	config.save("res://options.cfg")

func load_options():
	var fullscreen = config.get_value("Options", "fullscreen", false)
	var vsync = config.get_value("Options", "vsync", false)
	
	print(fullscreen)
	FullscreenCheckButton.button_pressed = fullscreen
	
	VsyncCheckButton.set_pressed_no_signal(vsync)
	VsyncCheckButton.emit_signal("toggled", vsync)

func _ready():
	load_options()

func _on_resume_pressed():
	save_options()
	get_node(PauseController).resume()
	get_tree().set_deferred("paused", false)

func _on_fullscreen_check_button_toggled(button_pressed):
	if button_pressed and DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_v_sync_check_button_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_menu_pressed():
	get_node(PauseController).resume()
	get_tree().change_scene_to_file("res://scenes/ChooseLevelMenu.tscn")

func _on_exit_pressed():
	get_node(PauseController).resume()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
