extends Resource
class_name Dialogue_Resource

@export var first_dialog : Array[String]
@export var warning_dialog : Array[String]
@export var switch_dialog : Array[String]
@export var flip_movement_dialog : Array[String]
@export var random_movement_dialog : Array[String]

var first : bool = false
var warning : bool = false
var switch : bool = false
var flip_movement : bool = false
var random_movement : bool = false
	
func get_first_dialog() -> String:
	if first:
		return ""
		
	first = true
	return first_dialog[randi_range(0, first_dialog.size() - 1)]
	
func get_warning_dialog() -> String:
	if warning:
		return ""
		
	warning = true
	return warning_dialog[randi_range(0, warning_dialog.size() - 1)]
	
func get_switch_dialog() -> String:
	if switch:
		return ""
		
	switch = true
	return switch_dialog[randi_range(0, switch_dialog.size() - 1)]
	
func get_flipped_movement_dialog() -> String:
	if flip_movement:
		return ""
		
	flip_movement = true
	return flip_movement_dialog[randi_range(0, flip_movement_dialog.size() - 1)]
	
func get_random_movement_dialog() -> String:
	if random_movement:
		return ""
		
	random_movement = true
	return random_movement_dialog[randi_range(0, random_movement_dialog.size() - 1)]
