extends Control

var air : PackedScene = preload("res://Scenes/Spawnable Objects/Friendly/air_slime.tscn")
var earth : PackedScene = preload("res://Scenes/Spawnable Objects/Friendly/earth_slime.tscn")
var fire : PackedScene = preload("res://Scenes/Spawnable Objects/Friendly/fire_slime.tscn")
var ice : PackedScene = preload("res://Scenes/Spawnable Objects/Friendly/ice_slime.tscn")
var obsidian : PackedScene = preload("res://Scenes/Spawnable Objects/Friendly/obsidian_slime.tscn")
var storm : PackedScene = preload("res://Scenes/Spawnable Objects/Friendly/storm_slime.tscn")

@onready var player_ref = get_tree().get_root().get_node("Main/player")
@onready var spawner_ref = get_tree().get_root().get_node("Main/spawner")

var air_count : float
var earth_count : float
var water_count : float
var fire_count : float

var mob

func _process(delta):
	air_count = player_ref.get_air()
	earth_count = player_ref.get_earth()
	water_count = player_ref.get_water()
	fire_count = player_ref.get_fire()
	
func _on_obsidian_pressed():
	if water_count >= 2 and fire_count >= 2:
		mob = obsidian.instantiate()
		mob.position = spawner_ref.get_node("Marker2D").global_position
		get_tree().get_root().add_child(mob)
		player_ref.resources_dict[player_ref.main.element_types.WATER] -= 2
		player_ref.resources_dict[player_ref.main.element_types.FIRE] -= 2

func _on_storm_pressed():
	if air_count >= 2 and fire_count >= 2:
		mob = storm.instantiate()
		mob.position = spawner_ref.get_node("Marker2D").global_position
		get_tree().get_root().add_child(mob)
		player_ref.resources_dict[player_ref.main.element_types.AIR] -= 2
		player_ref.resources_dict[player_ref.main.element_types.FIRE] -= 2


func _on_fire_pressed():
	if earth_count >= 2 and fire_count >= 2:
		mob = fire.instantiate()
		mob.position = spawner_ref.get_node("Marker2D").global_position
		get_tree().get_root().add_child(mob)
		player_ref.resources_dict[player_ref.main.element_types.EARTH] -= 2
		player_ref.resources_dict[player_ref.main.element_types.FIRE] -= 2


func _on_air_pressed():
	if air_count >= 2 and earth_count >= 2:
		mob = air.instantiate()
		mob.position = spawner_ref.get_node("Marker2D").global_position
		get_tree().get_root().add_child(mob)
		player_ref.resources_dict[player_ref.main.element_types.AIR] -= 2
		player_ref.resources_dict[player_ref.main.element_types.EARTH] -= 2

func _on_earth_pressed():
	if water_count >= 2 and earth_count >= 2:
		mob = earth.instantiate()
		mob.position = spawner_ref.get_node("Marker2D").global_position
		get_tree().get_root().add_child(mob)
		player_ref.resources_dict[player_ref.main.element_types.WATER] -= 2
		player_ref.resources_dict[player_ref.main.element_types.EARTH] -= 2

func _on_ice_pressed():
	if air_count >= 2 and water_count >= 2:
		mob = ice.instantiate()
		mob.position = spawner_ref.get_node("Marker2D").global_position
		get_tree().get_root().add_child(mob)
		player_ref.resources_dict[player_ref.main.element_types.AIR] -= 2
		player_ref.resources_dict[player_ref.main.element_types.WATER] -= 2
