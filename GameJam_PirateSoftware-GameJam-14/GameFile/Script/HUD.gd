extends Control

@export var corruption_dialog : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_node = get_node("/root/Main")
	var player_node = get_node("/root/Main/Player")
	$HealthBar.max_value = GlobalData.player_max_health
	$HealthBar/Label.text = str(GlobalData.player_max_health)
	player_node.connect("update_health_bar", set_health_bar)
	set_health_bar()
	
	$CorruptionBar.max_value = GlobalData.corruption_max_level
	player_node.connect("update_corruption_bar", set_corruption_bar)
	set_corruption_bar()

	$LightBar.max_value = GlobalData.default_light_timer_seconds
	main_node.connect("update_timer_bar", set_timer_bar)
	set_timer_bar()
	
	$Label.text = "";

func set_health_bar():
	$HealthBar.value = GlobalData.player_cur_health
	$HealthBar/Label.text = str(GlobalData.player_cur_health)

func set_corruption_bar():
	$CorruptionBar.value = GlobalData.corruption_cur_level
		
	if floor(GlobalData.corruption_cur_level) == 2:
		set_dialog_text(corruption_dialog.get_first_dialog())
		
	if floor(GlobalData.corruption_cur_level) == 50:
		set_dialog_text(corruption_dialog.get_warning_dialog())

	if floor(GlobalData.corruption_cur_level) == 60:
		set_dialog_text(corruption_dialog.get_switch_dialog())

	if floor(GlobalData.corruption_cur_level) == 80:
		set_dialog_text(corruption_dialog.get_flipped_movement_dialog())

	if floor(GlobalData.corruption_cur_level) == 90:
		set_dialog_text(corruption_dialog.get_random_movement_dialog())

	
func set_timer_bar():
	$LightBar.value = GlobalData.current_light_timer_seconds

func set_keys_collected():
	$KeyIcon/KeyCollected.text = str(GlobalData.keys)

func set_dialog_text(text : String):
	if text == "":
		return
	var tween = create_tween().bind_node($Label)
	tween.set_loops(0)

	$Label.modulate.a = 0.0 
	tween.tween_property($Label, "modulate:a", 1.0, 1)
	$Label.text = text
	$Label/Timer.start()

func _on_timer_timeout():
	var tween = create_tween().bind_node($Label)
	tween.set_loops(0)

	$Label.modulate.a = 1.0 
	tween.tween_property($Label, "modulate:a", 0.0, 1)
