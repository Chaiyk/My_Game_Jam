class_name UI extends Node

@export var main: Main

@export var resource_ui_card_template: PackedScene
@export var generator_info_popup_template: PackedScene

@onready var resource_cards_container: VBoxContainer = $"Resources VBoxContainer"
@onready var upgrade_actions_container: VBoxContainer = $"Upgrade Actions VBoxContainer"


@onready var canvas_layer: CanvasLayer = self.get_parent()

var resource_cards: Dictionary

func setup() -> void:
	# remove any existing nodes
	for resource_card in resource_cards_container.get_children():
		resource_card.queue_free()
	
	for upgrade_button in upgrade_actions_container.get_children():
		upgrade_button.queue_free()
	
	
	# create a label and button node for each element in player's inventory
	for element_index in main.player.resources_dict:
		var element_name = Main.element_types.find_key(element_index)
		var _name: String = (element_name + " Info").capitalize()
		
		var resource_card: ResourceUICard = resource_ui_card_template.instantiate()
		resource_cards[element_index] = resource_card
		resource_card.setup(element_name, 0)
		resource_cards_container.add_child(resource_card)
		
		var info_button := Button.new()
		info_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		info_button.set_custom_minimum_size(Vector2(150, 40))
		info_button.pressed.connect(popup_generator_info.bind(element_index))
		info_button.name = _name
		info_button.text = _name
		upgrade_actions_container.add_child(info_button)

func popup_generator_info(element_index: int) -> void:
	if main.generator_dict[element_index] == null:
		return
	
	var generator_info_popup: GeneratorInfoPopup = generator_info_popup_template.instantiate()
	generator_info_popup.setup(element_index, main)
	canvas_layer.add_child(generator_info_popup)
	pass
