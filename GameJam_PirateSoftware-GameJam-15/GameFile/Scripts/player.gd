class_name Player extends Node

@export var main: Main

var resources_dict := Dictionary()
var signals := Signals.new()

# initialize player's inventory with elements from Main.element_types
func setup_resources_dictionary():
	for element_index in Main.element_types.values():
		resources_dict[element_index] = 0

func update_resources(_element_index, _amount):
	resources_dict[_element_index] += _amount
	var element_name: String = Main.element_types.find_key(_element_index)
	main.ui.resource_cards[_element_index].setup(element_name, resources_dict[_element_index])

func get_air():
	return resources_dict[main.element_types.AIR]
	
func get_earth():
	return resources_dict[main.element_types.EARTH]
	
func get_water():
	return resources_dict[main.element_types.WATER]
	
func get_fire():
	return resources_dict[main.element_types.FIRE]
