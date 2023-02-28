extends Camera2D

func _ready():
	limit_top=-200
	limit_bottom=700
	
func _process(delta):
	var window_size = OS.get_window_size()
	
	zoom.x = (abs(limit_top) + abs(limit_bottom)) / window_size.y
	zoom.y = (abs(limit_top) + abs(limit_bottom)) / window_size.y 
