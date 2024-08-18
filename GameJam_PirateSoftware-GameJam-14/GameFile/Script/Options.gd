extends Control

@export var master_slider : HSlider
@export var music_slider : HSlider
@export var effect_slider : HSlider

@export var master_bus_name : String
@export var music_bus_name : String
@export var effect_bus_name : String

@onready var master_bus := AudioServer.get_bus_index(master_bus_name)
@onready var music_bus := AudioServer.get_bus_index(music_bus_name)
@onready var effect_bus := AudioServer.get_bus_index(effect_bus_name)

func _ready():
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	effect_slider.value = db_to_linear(AudioServer.get_bus_volume_db(effect_bus))

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_slider.value))

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_slider.value))

func _on_effect_value_changed(value):
	AudioServer.set_bus_volume_db(effect_bus, linear_to_db(effect_slider.value))

func _on_master_mouse_exited():
	release_focus()

func _on_music_mouse_exited():
	release_focus()

func _on_effect_mouse_exited():
	release_focus()
	
func _input(event):
	if event.is_action_pressed("Return"):
		#get_tree().get_root().get_node("Main/CanvasLayer/Pause").option_active = false
		queue_free()

func _on_back_pressed():
	queue_free()
