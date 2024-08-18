extends Node2D

@export_file("*.tscn") var end_scene_path : String

@onready var tilemap = get_node("TileMap")
@onready var player_node = get_node("Player")

var seconds_per_frame := (1.0 / Engine.max_fps)
var break_time_seconds  = (Engine.max_fps * 1.2) * seconds_per_frame
var respawn_time_seconds := (Engine.max_fps * 5.0) * seconds_per_frame
var breaking_tiles : Array[Vector2]
var snake_cell_array_ref

func _ready():
	$Star.play_fly_animation()
	player_node.connect("link_snake_cell", link_snake_cell)
	snake_cell_array_ref = player_node.get_snake_cells()
	
	for cells in snake_cell_array_ref:
		cells.connect("on_breakable_tile", on_breakable_tile)
		
	player_node.connect("end_game", end_game)
	$Star.connect("end_game", end_game)

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func on_breakable_tile(tile_coordinate : Vector2):
	if breaking_tiles.has(tile_coordinate):
		return;
	
	breaking_tiles.append(tile_coordinate)
	await get_tree().create_timer(break_time_seconds).timeout
	tilemap.erase_cell(1, tile_coordinate)
	await get_tree().create_timer(respawn_time_seconds).timeout
	var tile_atlas_id := Vector2(4, 5)
	tilemap.set_cell(1, tile_coordinate, 0, tile_atlas_id)
	breaking_tiles.erase(tile_coordinate)

func end_game(is_win : bool, title_text : String, start_time : float, total_moves : int):
	var new_scene = load(end_scene_path)
	var new_scene_instance = new_scene.instantiate()
	new_scene_instance.name = "End Menu"
	new_scene_instance.setup(is_win, title_text, start_time, total_moves)
	get_parent().add_child(new_scene_instance)
	queue_free()

func link_snake_cell(snake_cell):
	snake_cell.connect("on_breakable_tile", on_breakable_tile)
