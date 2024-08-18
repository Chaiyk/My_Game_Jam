extends AnimatedSprite2D

@export var is_head : bool

signal on_breakable_tile

var head_cell
var curr_facing_direction := Vector2(1, 0) #Right
var prev_facing_direction := Vector2(0, 0)
var prev_position = null

var tilemap

func _ready():
	head_cell = get_node("../../Player")
	tilemap = get_node("../../TileMap")
	
func _process(_delta):
	var tile_position = tilemap.local_to_map(global_position)
	is_on_breakable(tile_position)

func _on_area_2d_body_entered(body):
	if body is TileMap:
		head_cell.update_platform_count(1)

func _on_area_2d_body_exited(body):
	if body is TileMap:
		head_cell.update_platform_count(-1)

func is_on_breakable(tile_position):
	if tilemap.get_cell_source_id(1, tile_position - Vector2i(0 , -1)) == 0:
		on_breakable_tile.emit(tile_position - Vector2i(0 , -1))
