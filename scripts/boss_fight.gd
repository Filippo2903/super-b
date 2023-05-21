extends Node2D

func _ready():
	get_node("Player").get_node("Camera2D").limit_left = 10
	get_node("Player").get_node("Camera2D").limit_right = 1350
