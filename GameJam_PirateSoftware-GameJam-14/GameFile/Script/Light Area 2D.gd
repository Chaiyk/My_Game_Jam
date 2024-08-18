extends Area2D

func _on_body_entered(body):
	if body.has_method("update_light_sources"):
		body.update_light_sources(1)

func _on_body_exited(body):
	if body.has_method("update_light_sources"):
		body.update_light_sources(-1)
