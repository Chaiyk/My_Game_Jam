class_name Main extends Node2D

@export var generator_template: PackedScene

@onready var player: Player = %player
@onready var ui: UI = $CanvasLayer/UI

var generator_dict: Dictionary
var on_right : bool = false
var on_left : bool = false

enum element_types {
	EARTH,
	WATER,
	FIRE,
	AIR,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.setup_resources_dictionary()
	ui.setup()
	
	setup_generator_dict()
	spawn_generator(element_types.EARTH, 1, 5)
	spawn_generator(element_types.WATER, 1, 1)
	spawn_generator(element_types.FIRE, 1, 1)
	spawn_generator(element_types.AIR, 1, 5)

# setup to store refences for each generator nodes
func setup_generator_dict() -> void:
	for element_index in element_types.values():
		generator_dict[element_index] = null

func spawn_generator(_element_index, _generating_speed, _generate_amount) -> void:
	var generator: Generator = generator_template.instantiate()
	generator_dict[_element_index] = generator
	add_child(generator)
	generator.setup(_element_index, _generating_speed, _generate_amount, player)

func upgrade_generator(element_index):
	var generator: Generator = generator_dict[element_index]
	if generator == null:
		print("generator not found")
		return
		
	if player.resources_dict[element_index] >= generator.upgrade_resources_required:
		print("upgrading generator")
		player.update_resources(element_index, -generator.upgrade_resources_required)
		generator.upgrade_generator()
	else:
		print("not enough resources")

func _process(delta):
	if on_right and $Camera2D.position.x < 2550:
		$Camera2D.position.x += 5
	elif on_left and $Camera2D.position.x > 514:
		$Camera2D.position.x -= 5
		
	#print($Camera2D.position.x)

func _on_right_mouse_entered():
	on_right = true

func _on_right_mouse_exited():
	on_right = false

func _on_left_mouse_entered():
	on_left = true

func _on_left_mouse_exited():
	on_left = false
