extends Node2D
class_name Generator

@export var element_index: Main.element_types
@export var generator_tier: int = 1
@export var generating_speed: float = 2
@export var generate_amount: int = 1


var upgrade_resources_required = 10
var upgrade_resources_required_multipliyer = 1.5
var upgrade_speed_increase = 0
var upgrade_amount_increase = 1

var timer: Timer
var player: Player

func setup(_element_index, _generating_speed, _generate_amount, _player) -> void:
	player = _player
	element_index = _element_index
	generating_speed = _generating_speed
	generate_amount = _generate_amount
	
	var element_name = Main.element_types.find_key(element_index)
	name = element_name + " Generator"
	
	setup_timer()
	add_child(timer)
	timer.start()

func setup_timer() -> void:
	timer = Timer.new()
	timer.one_shot = false
	timer.autostart = false
	timer.wait_time = generating_speed
	timer.timeout.connect(on_timer_complete)

func upgrade_generator() -> void:
	timer.stop()
	generator_tier += 1
	generating_speed += upgrade_speed_increase
	generate_amount += upgrade_amount_increase
	upgrade_resources_required *= upgrade_resources_required_multipliyer
	upgrade_resources_required = ceili(upgrade_resources_required)
	timer.start()

func on_timer_complete() -> void:
	player.update_resources(element_index, generate_amount)
	pass
