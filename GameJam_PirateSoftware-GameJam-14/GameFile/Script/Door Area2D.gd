extends Interactable

@export_file("*.tscn") var scene_path : String
@export var required_keys : int
var spawn_position
var final_level = false
var hud_ref

func _ready():
	$"Key Label".text = str(required_keys)
	hud_ref = get_node("/root/Main/CanvasLayer/Hud")

func set_pos(next_position):
	spawn_position = next_position
	print("Called")
	print(spawn_position)

func interact(body):
	if GlobalData.keys < required_keys:
		print("not enough keys")
		return
	
	print("open door")
	GlobalData.keys = 0
	var camera = get_tree().root.get_node("Main/Player/Camera2D")
	if !final_level:
		get_tree().root.get_node("Main/Player").global_position = spawn_position
		camera.global_position = spawn_position
		camera.reset_smoothing()
	super.interact(body)
	hud_ref.set_keys_collected()
	
	if final_level:
		get_tree().change_scene_to_file("res://Scene/Congratulations.tscn")
