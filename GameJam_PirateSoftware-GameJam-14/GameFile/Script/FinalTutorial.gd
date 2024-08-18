extends Node2D

@export var key : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_loc1 = get_node("KeySpawn").global_position
	var spawn_loc2 = get_node("KeySpawn2").global_position
	var key_loc = key.instantiate()
	
	if randf_range(0, 1) < 0.5:
		key_loc.global_position = spawn_loc1
	else:
		key_loc.global_position = spawn_loc2
	
	get_tree().root.get_node("Main/Level").add_child(key_loc)
	$DoorArea2d.spawn_position = get_tree().root.get_node("Main/Level2/SpawnPoint").global_position
