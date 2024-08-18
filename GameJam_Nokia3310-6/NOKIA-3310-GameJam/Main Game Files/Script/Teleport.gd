extends Node2D

@export var teleport_x : int
@export var teleport_y : int

@onready var player_node = get_tree().root.get_node("Main/Screen/GameInstance/Player")

var teleport_loc : Vector2

func _ready():
	teleport_loc = Vector2(teleport_x, teleport_y)

func _on_area_2d_area_entered(area):
	if area.name == "Area2D2":
		area.get_parent().get_parent().gate_interact = true
		area.get_parent().get_parent().teleport_coordinates = teleport_loc
