extends "res://Scripts/monster.gd"

func _process(delta):
	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("Walking")

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.stop()
