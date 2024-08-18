extends Control
class_name GeneratorInfoPopup

@export var title_label: Label

@export var current_tier_label: Label
@export var current_speed_label: Label
@export var current_amount_label: Label

@export var upgraded_tier_label: Label
@export var upgraded_speed_label: Label
@export var upgraded_amount_label: Label

@export var resources_required_label: Label

@export var close_button: Button
@export var upgrade_button: Button

var main: Main
var element_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close_button.pressed.connect(close_popup)
	upgrade_button.pressed.connect(upgrade_generator)

func setup(_element_index: int, _main: Main) -> void:
	main = _main
	element_index = _element_index
	setup_labels()

func setup_labels() -> void:
	var element_name = Main.element_types.find_key(element_index)
	var _name: String = (element_name + " Info").capitalize()
	var generator: Generator = main.generator_dict[element_index]
	
	name = _name + " Popup"
	title_label.text = _name
	
	current_tier_label.text = "Generator Tier: " + str(generator.generator_tier)
	current_speed_label.text = "Generating Speed: " + str(generator.generating_speed)
	current_amount_label.text = "Generating Amount: " + str(generator.generate_amount)
	
	upgraded_tier_label.text = "Generator Tier: " + str(generator.generator_tier + 1)
	upgraded_speed_label.text = "Generating Speed: " + str(generator.generating_speed + generator.upgrade_speed_increase)
	upgraded_amount_label.text = "Generating Amount: " + str(generator.generate_amount + generator.upgrade_amount_increase)
	
	resources_required_label.text = "Require " + str(generator.upgrade_resources_required) + " To Upgrade"

func upgrade_generator() -> void:
	main.upgrade_generator(element_index)
	setup_labels()

func close_popup() -> void:
	queue_free()
