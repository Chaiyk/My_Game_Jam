extends Node2D

@export var snake_body : PackedScene

signal end_game
signal link_snake_cell

var audio_manager

#Fall
var seconds_per_frame := (1.0 / Engine.max_fps)
var gravity_fall_seconds := (Engine.max_fps / 2.0) * seconds_per_frame
var falling := false
var fall_stun_seconds := (Engine.max_fps) * seconds_per_frame
var fall_height := 0
var fall_stun_start := false
var has_fall_stun := false

var total_moves : int = 0
var start_time : float = 0
var snake_cell_size : int = 6
var snake_cell_length : int = 3 #amount of body length, excuding head
var snake_cell_array : Array = []

var platform_count : int = 0
var on_platform : bool = true

var eat_audio : bool = false
var star_animation_active : bool = true

var gate_interact : bool = false
var teleport_coordinates : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_manager = get_tree().root.get_node("Main/Screen/Audio Manager")
	#Snake Length - add child note
	for length in snake_cell_length:
		var snake_segment = snake_body.instantiate()
		add_child(snake_segment)

	#Snake Length - add node to an array and setting position
	for snake_cell in self.get_children():
		snake_cell.play("Right")
		if !snake_cell_array.is_empty():
			for cell in snake_cell_array:
				cell.position += snake_cell_size * Vector2(1, 0)
		snake_cell_array.append(snake_cell)
	
	print(snake_cell_array)
	audio_manager.play("Audio_Start_Game")
	
	start_time = Time.get_ticks_msec()
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Movement Button
	if Input.is_action_just_pressed("movement_keys"):
		var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		move_snake(movement)
	
	#Gravity Stuff
	if !on_platform && !falling:
		falling = true
		
		fall_height += 1
		if fall_height >= 2:
			has_fall_stun = true
			
		gravity_drop()
		await get_tree().create_timer(gravity_fall_seconds).timeout
		falling = false
	
	if on_platform:
		if !fall_stun_start && has_fall_stun:
			fall_stun_start = true
			set_stun_direction(true)
			await get_tree().create_timer(fall_stun_seconds).timeout
			set_stun_direction(false)
			fall_stun_start = false
			has_fall_stun = false

#When snake touch something
func _on_area_2d_2_area_entered(area):
	#when snake touch food
	if area.has_method("food_touched"):
		audio_manager.play("Audio_Eat")
		area.food_touched()
		call_deferred("grow_length")

func move_snake(movement : Vector2):
	var new_head_pos = snake_cell_array[0].global_position + snake_cell_size * movement
	if new_head_pos.x == 87:
		new_head_pos = Vector2(3, new_head_pos.y)
	elif new_head_pos.x == -3:
		new_head_pos = Vector2(81, new_head_pos.y)
		
	if !can_move(movement, new_head_pos):
		return
		
	total_moves += 1
		
	if gate_interact:
		new_head_pos = teleport_coordinates
		gate_interact = false
		
	var prev_cell = null
	
	for curr_cell in snake_cell_array:
		var facing_direction : Vector2
		
		curr_cell.prev_position = curr_cell.global_position
		curr_cell.prev_facing_direction = curr_cell.curr_facing_direction
		if curr_cell.is_head:
			curr_cell.curr_facing_direction = movement
			curr_cell.prev_facing_direction = curr_cell.curr_facing_direction
			facing_direction = movement
			
			curr_cell.global_position = new_head_pos;
		else:
			curr_cell.curr_facing_direction = prev_cell.prev_facing_direction
			facing_direction = prev_cell.prev_facing_direction
			
			curr_cell.global_position = prev_cell.prev_position
			
		set_cell_direction(curr_cell, facing_direction)
		
		prev_cell = curr_cell
		
	# test if will collide with body
	for curr_cell in snake_cell_array:
		if curr_cell == snake_cell_array[0]:
			continue
		if snake_cell_array[0].global_position == curr_cell.global_position:
			await get_tree().create_timer(0.1).timeout
			emit_end_game_signal(false, "You Ate Yourself")
			break

func can_move(movement : Vector2, new_head_pos : Vector2):
	if !on_platform || has_fall_stun:
		audio_manager.play("Audio_Unmovable")
		return false
		
	#player cant turn 180
	var head_cell = snake_cell_array[0]
	if head_cell.curr_facing_direction * -1 == movement:
		return false
	
	#Player cant move when star is active
	if star_animation_active:
		return false
		
	# test if moving diagonally
	if abs(movement) != Vector2(1, 0) && abs(movement) != Vector2(0, 1):
		return false
		
	if gate_interact:
		audio_manager.play("Audio_Teleport")
		return true
		
	#test if will collide with platforms
	var tilemap = get_node("../TileMap")
	var tile_position = tilemap.local_to_map(new_head_pos)
	if tilemap.get_cell_source_id(0, tile_position) != -1:
		return false
		
	if tilemap.get_cell_source_id(1, tile_position) != -1:
		return false
	
	audio_manager.play("Audio_Move")
	return true

func set_cell_direction(cell, direction):
	if direction.x < 0:
		cell.play("Left")
	elif direction.x > 0:
		cell.play("Right")
		
	if direction.y < 0:
		cell.play("Up")
	elif direction.y > 0:
		cell.play("Down")

func set_stun_direction(is_stun : bool):
	var current_animation = $Head.get_animation()
	if is_stun:
		if current_animation == "Up":
			$Head.play("Stun Up")
		if current_animation == "Down":
			$Head.play("Stun Down")
		if current_animation == "Left":
			$Head.play("Stun Left")
		if current_animation == "Right":
			$Head.play("Stun Right")
			
	if !is_stun:
		if current_animation == "Stun Up":
			$Head.play("Up")
		if current_animation == "Stun Down":
			$Head.play("Down")
		if current_animation == "Stun Left":
			$Head.play("Left")
		if current_animation == "Stun Right":
			$Head.play("Right")

func update_platform_count(n):
	on_platform = true
	platform_count += n
	if platform_count <= 0:
		on_platform = false
	else:
		fall_height = 0

#Gravity to make snake fall
func gravity_drop():
	for curr_cell in snake_cell_array:
		curr_cell.position.y += snake_cell_size

#Grow Snake Length
func grow_length():
	var snake_segment = snake_body.instantiate()
	snake_segment.position = Vector2(-50, -50)
	add_child(snake_segment)
	snake_cell_array.append(snake_segment)
	link_snake_cell.emit(snake_segment)

func get_snake_cells():
	return snake_cell_array

func emit_end_game_signal(is_win : bool, title : String):
	end_game.emit(is_win, title, start_time, total_moves)
