class_name ResourceUICard extends Control

func setup(element_name: String, amount: int) -> void:
	var label: Label = $Label
	name = (element_name + " Label").capitalize()
	label.text = (element_name + ": " + str(amount)).capitalize()
