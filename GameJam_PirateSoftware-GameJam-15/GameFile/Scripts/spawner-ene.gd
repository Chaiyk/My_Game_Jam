extends Node2D

var enemy_norm = preload("res://Scenes/Spawnable Objects/Enemies/shadow_normal.tscn")
var enemy_spd = preload("res://Scenes/Spawnable Objects/Enemies/shadow_speed.tscn")
var enemy_tank = preload("res://Scenes/Spawnable Objects/Enemies/shadow_tank.tscn")

var rng = RandomNumberGenerator.new()
var mob

func _on_timer_timeout():
	var number = rng.randi_range(1,3)

	if number == 1:
		mob = enemy_norm.instantiate()
	elif number == 2:
		mob = enemy_spd.instantiate()
	elif number == 3:
		mob = enemy_tank.instantiate()
		
	mob.global_position = $Marker2D.global_position
	get_tree().get_root().add_child(mob)
