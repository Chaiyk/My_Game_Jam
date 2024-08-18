extends Control
class_name Menu

@export_file("*.tscn") var target_scene_path : String

var wait_timer = 0.3
var waited := false

func _ready():
	fade_text_in_and_out()

func fade_text_in_and_out():
	#appear
	$Continue.modulate.a = 1.0
	await get_tree().create_timer(0.5).timeout
	
	#disappear
	$Continue.modulate.a = 0.0
	await get_tree().create_timer(0.5).timeout
	
	fade_text_in_and_out()
