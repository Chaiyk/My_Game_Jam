extends Node2D

signal end_game

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "FlyUp":
		position = Vector2(position.x, -600)
		$AnimatedSprite2D.play("Idle")
		get_tree().root.get_node("Main/Screen/GameInstance/Player").star_animation_active = false

func _on_area_2d_area_entered(area):
	if area.get_parent().name == "Head":
		area.get_parent().get_parent().emit_end_game_signal(true, "You Won!")

func play_fly_animation():
	$AnimatedSprite2D.play("FlyUp")
