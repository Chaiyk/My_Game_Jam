extends Control

var options

func _input(event):
	if event.is_action_pressed("Return") and get_tree().paused and !options:
		get_tree().paused = not get_tree().paused
		#queue_free()

func _on_options_pressed():
	print("pressed")
	options = load("res://Scene/Options.tscn").instantiate()
	get_tree().current_scene.get_node("CanvasLayer").add_child(options)	
	
func _on_exit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	get_tree().paused = not get_tree().paused
	get_tree().get_root().get_node("Main").pressed = 0
	visible = false

func _on_menu_pressed():
	get_tree().paused = not get_tree().paused
	GlobalData.game_start = false
	get_tree().change_scene_to_file("res://Scene/Menu.tscn")
