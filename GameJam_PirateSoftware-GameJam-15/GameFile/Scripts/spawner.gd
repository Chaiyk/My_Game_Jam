extends Node2D

var air = preload("res://Scenes/Spawnable Objects/Friendly/air_slime.tscn")
var earth = preload("res://Scenes/Spawnable Objects/Friendly/earth_slime.tscn")
var fire = preload("res://Scenes/Spawnable Objects/Friendly/fire_slime.tscn")
var ice = preload("res://Scenes/Spawnable Objects/Friendly/ice_slime.tscn")
var obsidian = preload("res://Scenes/Spawnable Objects/Friendly/obsidian_slime.tscn")
var storm = preload("res://Scenes/Spawnable Objects/Friendly/storm_slime.tscn")


func _process(delta):
	$AnimatedSprite2D.play("Bubbling")

func ft_spawn(mob):
	mob.global_position = $Marker2D.global_position
	get_tree().get_root().add_child(mob)

func _on_timer_timeout():
	ft_spawn(air.instantiate())
