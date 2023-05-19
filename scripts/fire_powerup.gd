extends CharacterBody2D

func _on_hit(body):
	body.status_power_up()
	queue_free()
