extends Node

var map_size : int = 5
var room_size_x : int = 700
var room_size_y : int = 500
var type_of_rooms = {}
var rooms = ["Start", "End", "Key1", "Key2", "Key3", "Key4"]
var scene = preload("res://zBin/Test Map.tscn")

func map_generation():
#Creating Array in Dictionary
	for y in map_size:
		type_of_rooms[y] = []
		for x in map_size:
			if type_of_rooms[y].is_empty():
				type_of_rooms[y] = ["Path"]
			else:
				type_of_rooms[y].append("Path")

#Put Rooms in Dictionary
	for i in rooms:
		type_of_rooms[randi_range(0, map_size - 1)][randi_range(0, map_size - 1)] = i

#instantiate Scenes
	for x in map_size:
		for y in map_size:
			var ins_scene = scene.instantiate()
			ins_scene.position = Vector2(room_size_x * x, room_size_y * y)
			add_child(ins_scene)

#Printing Dictionary
	print(type_of_rooms[0])
	print(type_of_rooms[1])
	print(type_of_rooms[2])
	print(type_of_rooms[3])
	print(type_of_rooms[4])
	print()

func _physics_process(delta):
	if Input.is_action_just_pressed("Down"):
		map_generation()
