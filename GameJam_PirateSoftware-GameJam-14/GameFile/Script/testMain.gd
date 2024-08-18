extends Node2D

const MINUTE = 60.0
var timer : float = 0
var pressed = 0

signal update_timer_bar

var player_node
var pause_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = $Player
	if !GlobalData.game_start:
		player_node.position = get_node("Level1/SpawnPoint").global_position
		GlobalData.current_light_timer_seconds = GlobalData.default_light_timer_seconds
		GlobalData.player_cur_health = GlobalData.player_max_health
		GlobalData.game_start = true
		player_node.update_light_scale()
		player_node.update_health_bar.emit()
	
	#Initialize pause menu
	pause_ref = preload("res://Scene/Pause.tscn").instantiate()
	get_tree().current_scene.get_node("CanvasLayer").add_child(pause_ref)
	pause_ref.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalData.pause_game || GlobalData.game_over:
		return
	
	if !GlobalData.freeze_light_timer:
		GlobalData.current_light_timer_seconds -= delta
		update_timer_bar.emit()
		player_node.update_light_scale()
	
	if !GlobalData.freeze_corruption_timer:
		if GlobalData.in_darkness_timer < GlobalData.max_darkness_timer:
			GlobalData.in_darkness_timer += delta
		else:
			GlobalData.in_darkness_timer = GlobalData.max_darkness_timer
		player_node.update_corruption(delta)
	else:
		GlobalData.in_darkness_timer = 0
	
	#Pressing escape would open up pause menu
	if Input.is_action_just_pressed("Return") and pressed == 0:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		pause_ref.visible = new_pause_state
		pressed += 1
	#Pressing it again would close it
	elif Input.is_action_just_pressed("Return") and pressed == 1:
		pressed = 0
		pause_ref.visible = get_tree().paused
