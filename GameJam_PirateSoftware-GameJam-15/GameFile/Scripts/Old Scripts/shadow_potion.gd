extends Potion

@export var speed : float = 400
@export var gravity : float = 500

func setup_potion():
	pot_speed = speed
	pot_grav = gravity


#Insert unique potion logic here

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Potion:
		return
		
	break_potion()
	if area.get_parent() is Platform:
		_handle_platform_collision(area)
	
	if area.get_parent() is Player:
		_handle_player_collision(area)

func _handle_platform_collision(area: Area2D) -> void:
	var platform : Platform = area.get_parent()
	platform.call_deferred("update_platform_type", platform.platform_type.shadow)

func _handle_player_collision(area: Area2D) -> void:
	var player : Player = area.get_parent()
	player.call_deferred("update_player_type", player.player_type.shadow)
