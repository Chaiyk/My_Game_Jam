extends Menu

var audio_manager

var executed := false
var is_win := false

func setup(is_win : bool, title_text : String, start_time : float, total_moves : int):
	self.is_win = is_win
	$Title.text = title_text
	$Seconds.text = str((Time.get_ticks_msec() - start_time) / 1000) + " S"
	$Moves.text = str(total_moves) + " Moves"
	
func _ready():
	audio_manager = get_tree().root.get_node("Main/Screen/Audio Manager")
	
	$Seconds.visible = true
	$Moves.visible = true
	
	if is_win:
		audio_manager.play("Audio_Win")
	else:
		audio_manager.play("Audio_Death")
		$Seconds.visible = false

func _process(_delta):
	if !waited:
		await get_tree().create_timer(wait_timer).timeout
	waited = true
	
	if !Input.is_anything_pressed() || executed:
		return
		
	executed = true
	print("Restart Game")
	var new_scene = load(target_scene_path)
	var new_scene_instance = new_scene.instantiate()
	new_scene_instance.name = "End Menu"
	get_parent().add_child(new_scene_instance)
	queue_free()
