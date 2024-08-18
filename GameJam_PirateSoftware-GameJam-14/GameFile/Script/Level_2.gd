extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var key_ref = load("res://Scene/Key.tscn")
	var spawn_points = [get_node("KeySpawn").global_position, get_node("KeySpawn2").global_position, 
						get_node("KeySpawn3").global_position, get_node("KeySpawn4").global_position]
	
	for keys in $DoorArea2d.required_keys:
		var key = key_ref.instantiate()
		var key_position = randi_range(0, len(spawn_points) - 1)
		key.global_position = spawn_points[key_position]
		spawn_points.remove_at(key_position)
		key.top_level = true
		add_child(key)
	
	$DoorArea2d.spawn_position = get_tree().root.get_node("Main/Level3/SpawnPoint").global_position
