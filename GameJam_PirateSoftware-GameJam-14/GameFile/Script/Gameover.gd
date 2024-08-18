extends Control

func _ready():
	$"Lose Sound Effect".play()

func _on_retry_pressed():
	#Change this to level 1 once its done
	GlobalData.game_over = false
	GlobalData.game_start = false
	get_tree().change_scene_to_file("res://Scene/Main.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scene/Menu.tscn")
