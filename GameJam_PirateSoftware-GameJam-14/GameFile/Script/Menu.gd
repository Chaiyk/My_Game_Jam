extends Control

var first_time = first_time_playing.new()
var path = "user://save/"
var filename = "data.tres"

func _ready():
	GlobalData.game_over = false
	GlobalData.game_start = false
	check_directory(path)
	if ResourceLoader.exists(path + filename):
		load_data()
	first_time.load_data()

func check_directory(paths):
	DirAccess.make_dir_absolute(paths)

func load_data():
	first_time = ResourceLoader.load(path + filename).duplicate(true)

func save():
	ResourceSaver.save(first_time, path + filename)
	print("saved")

func _on_start_button_pressed():
	#if GlobalData.first_time:
		#first_time.first_time = !GlobalData.first_time
		#save()
		##get_tree().change_scene_to_file("res://Tutorial.tscn")
	#elif !GlobalData.first_time:
	get_tree().change_scene_to_file("res://Scene/Main.tscn")
	
func _on_options_button_pressed():
	var options = load("res://Scene/Options.tscn").instantiate()
	get_tree().current_scene.add_child(options)	

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scene/Credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
