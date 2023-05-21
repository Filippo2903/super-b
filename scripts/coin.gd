extends StaticBody2D

func _on_hit(body):
	var coin = 1 # coin++
	queue_free()
