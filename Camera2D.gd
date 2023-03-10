extends Camera2D


func _ready():
	limit_top=-650
	limit_bottom=250
	
func _process(delta):
	var window_size = float(get_window().get_size().y)
	var view_size = float (abs(limit_bottom - limit_top))
	#print(window_size.y)
	zoom.x = window_size  / view_size
	zoom.y = window_size  / view_size
