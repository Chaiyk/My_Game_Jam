#class_name OldPlayer extends CharacterBody2D
#
#@export var player_speed : float = 300
#@export var player_jump : float = 200
#@export var player_accel : float = 25
#@export var player_friction : float = 30
#@export var player_gravity : float = 150
#
#@export var jump_time_peak : float
#@export var jump_time_descent: float
#
#@onready var jump_velocity : float = ((2.0 * player_jump) / jump_time_peak) * -1.0
#@onready var jump_grav : float = ((-2.0 * player_jump) / (jump_time_peak * jump_time_peak)) * -1.0
#@onready var fall_grav : float = ((-2.0 * player_jump) / (jump_time_descent * jump_time_peak)) * -1.0
#
##Preloading all potion scenes
#var shadow_potion_obj : PackedScene = preload("res://Scenes/shadow_potion.tscn")
#var light_potion_obj : PackedScene = preload("res://Scenes/light_potion.tscn")
#
#var dir = Vector2.ZERO
#var current_slot : int = 1
#var shadow_count : int = 0
#var light_count : int = 0
#
#enum player_type {
	#default,
	#shadow,
	#light,
#}
#var current_player_type : player_type
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
	#
#func _physics_process(delta):
	#get_input(delta)
	#move_and_slide()
#
	#
#func get_input(delta):
	#$Player/Arm.look_at(get_global_mouse_position())
#
	#if $Player/Arm/Potion.global_position.x > $Player.global_position.x:
		#$Player/Arm.flip_v = false
	#
	#if $Player/Arm/Potion.global_position.x < $Player.global_position.x:
		#$Player/Arm.flip_v = true
	#
#
	#velocity.y += get_grav() * delta
	#
	#dir.x = Input.get_axis("Left","Right")
	#
	#if Input.is_action_just_pressed("Jump"):
		#velocity.y = jump_velocity
	#
	#if Input.is_action_just_pressed("Throw"):
		#throw_potion()
		#
	#if Input.is_action_just_pressed("Slot1"):
		#current_slot = 1
		#print("swapped to shadow")
	#
	#if Input.is_action_just_pressed("Slot2"):
		#current_slot = 2
		#print("swapped to light")
	#
	##Player acceleration towards a direction
	#if dir != Vector2.ZERO:
		#if dir.x == -1:
			#$Player.flip_h = true
		#else:
			#$Player.flip_h = false
		#$Player.play("Walking")
		#velocity.x = move_toward(velocity.x, dir.x * player_speed, player_accel)
	#elif dir == Vector2.ZERO:
		#add_friction(delta)
#
#
##Friction to slowly slow down the player
#func add_friction(delta):
	#velocity.x = move_toward(velocity.x, 0, player_friction)
#
#
##Player Gravity
#func get_grav():
	#return jump_grav if velocity.y > 0.0 else fall_grav
#
#
##Throw potion
#func throw_potion():
	#var potion = null
	#
	##Throw potion based on current potion slot
	#if current_slot == 1:
		#potion = shadow_potion_obj.instantiate()
		#shadow_count += 1
	#elif current_slot == 2:
		#potion = light_potion_obj.instantiate()
		#light_count += 1
	#else: 
		#return
	#
	#potion.setup_potion()
	#potion.throw_potion($Player/Arm/Potion.global_position, $Player/Arm.rotation)
	#get_tree().root.add_child(potion)
#
#func update_player_type(type: player_type) -> void:
	#current_player_type = type
	#self.collision_layer = current_player_type
	##var static_body_2d: Staticurrent_platform_typeayer = current_platform_type
