extends TileMap

var enemy_count = 2
var gap = Vector2(0,0)

@export var mob_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in enemy_count:
		var enemy_spawn = mob_scene.instantiate()
		enemy_spawn.position = get_node("SpawnPoint").position + gap
		gap.x += 20
		add_child(enemy_spawn)
		print("spawned")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
