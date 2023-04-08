extends Area2D

func _on_body_entered(body):
	body.status_up()
	get_parent().queue_free()
