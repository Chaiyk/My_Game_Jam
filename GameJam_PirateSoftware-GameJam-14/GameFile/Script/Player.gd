extends CharacterBody2D

signal update_corruption_bar
signal update_health_bar

@export var speed:float = 65

var light_node : Area2D
var light_sources : int

var previous_position : Vector2

var target_item
var interactables_array = []

var interact_label : Label
var interact_texture : TextureRect

var target_door : Area2D

var pause_ref
var escaped = 0

#Attack
var is_attacking = false
@export var damage = 1

#Test Knockback
var knockback_vector = Vector2.ZERO
@export var knockback_force = 0.5

#corruption effects
var random_switch_timer:float = 0;

var random_switch:bool = false
var flipped_vertical:bool = false
var flipped_horizontal:bool = false
var random_movement:bool = false

enum holdable {
	SWORD,
	TORCH,
}

var is_holding = holdable.TORCH;

func _ready():
	light_node = $"AnimatedSprite2D/Light Area2D"
	interact_label = $PickupTooltip
	interact_label.visible = false
	interact_texture = $PickupTooltip/PickupTexture
	$AnimatedSprite2D/Torch.visible = true
	$AnimatedSprite2D/Sword.visible = false
	$AnimatedSprite2D.play("Idle")

func _process(delta):
	handle_corruption_effects(delta)
	get_movement_input()
	
	if random_switch_timer <= 0:
		#random_switch_timer = randi_range(30, 60)
		random_switch_timer = 10
	
	if Input.is_action_just_pressed("Inventory 1") and !is_attacking:
		update_holding((holdable.SWORD))
		
	if Input.is_action_just_pressed("Inventory 2") and !is_attacking:
		update_holding((holdable.TORCH))
	
	if is_holding == holdable.SWORD:
		if Input.is_action_just_pressed("Attack") and !is_attacking:
			$"Sound Effect/Sword Swing".play()
			is_attacking = true
			$AnimatedSprite2D.play("Attack_P1")
			$AnimatedSprite2D/Sword.visible = false
			#attack_enemies()
	
	if previous_position != position && interactables_array.size() > 0:
		previous_position = position
		set_target_item()
		
	if Input.is_action_just_pressed("Interact") && target_item:
		target_item.interact(self)
	
	if GlobalData.game_over:
		get_tree().change_scene_to_file("res://Scene/Game Over.tscn")

func _physics_process(delta):
	#if Input.is_action_just_pressed("Return") and escaped == 0:
		#pause_ref = load("res://Scene/Pause.tscn").instantiate()
		#get_tree().current_scene.get_node("CanvasLayer").add_child(pause_ref)
		#get_tree().paused = true
		#escaped += 1
	#elif Input.is_action_just_pressed("Return") and escaped == 1:
		#escaped = 0

	move_and_collide((velocity + knockback_vector) * speed * delta)
	knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.5)

func handle_corruption_effects(delta):
	if GlobalData.corruption_cur_level >= 60:
		random_switch = true
		
	if !random_switch:
		return
	
	random_switch_timer -= delta
	if random_switch_timer > 0:
		return

	if is_holding == holdable.SWORD:
		update_holding(holdable.TORCH)
	else:
		update_holding(holdable.SWORD)
		
	if GlobalData.corruption_cur_level >= 80:
		flipped_vertical = false
		flipped_horizontal = false
		
		if randf() <= 0.5:
			flipped_vertical = true
		if randf() <= 0.5:
			flipped_horizontal = true
			
	if GlobalData.corruption_cur_level >= 90:
		random_movement = false
		if randf() <= 0.5:
			random_movement = true

func get_movement_input():
	var vertical_movement = Input.get_axis("Up", "Down")
	var horizontal_movement = Input.get_axis("Left", "Right")
	
	if flipped_vertical:
		vertical_movement *= -1
	if flipped_horizontal:
		horizontal_movement *= -1
	
	var input_direction = Vector2(horizontal_movement, vertical_movement)
	if random_movement:
		input_direction = Vector2(vertical_movement, horizontal_movement)

	input_direction = input_direction.normalized()

	#Handle sprite flipping
	if input_direction.x < 0 and !is_attacking:
		$AnimatedSprite2D.scale.x = 1
	elif input_direction.x > 0 and !is_attacking:
		$AnimatedSprite2D.scale.x = -1
	
	velocity = input_direction
	if input_direction and !is_attacking:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D/Sword.play("Walk_Sword")
		$AnimatedSprite2D/Torch.play("Walk_Torch")
	elif !is_attacking:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D/Sword.stop()
		$AnimatedSprite2D/Torch.stop()
		#velocity = Vector2.ZERO
	elif is_attacking:
		velocity = Vector2.ZERO
		$AnimatedSprite2D/Sword.stop()
		$AnimatedSprite2D/Torch.stop()

func update_light_sources(n : int):
	light_sources += n
	if light_sources > 0:
		GlobalData.freeze_corruption_timer = true;
		
		#Stop corruption sound
		$"Sound Effect/Corruption".stop()
	else:
		GlobalData.freeze_corruption_timer = false;
		
		#Start corruption sound
		#$"Sound Effect/Corruption".play()

func update_light_scale():
	if !is_instance_valid(light_node):
		return
	var candle_percentage = GlobalData.current_light_timer_seconds / GlobalData.default_light_timer_seconds;
	if candle_percentage > 0:
		var light_scale : float = GlobalData.default_light_scale * candle_percentage
		light_node.scale = Vector2(light_scale, light_scale)
	else:
		update_holding(holdable.SWORD)
		light_node.queue_free()

#var timer = 0.0
func update_corruption(delta):
	if GlobalData.corruption_cur_level >= GlobalData.corruption_max_level:
		GlobalData.corruption_cur_level = GlobalData.corruption_max_level
		#print("timer", timer)
		update_corruption_bar.emit()
		GlobalData.game_over = true
		print("Game Over!")
		return
	#timer += delta * 60
	#print(GlobalData.corruption_cur_level)
	var darkness_multiplier_rate := (GlobalData.in_darkness_timer / GlobalData.max_darkness_timer) + 1
	GlobalData.corruption_cur_level += ((darkness_multiplier_rate * GlobalData.max_flat_corruption_rate) * GlobalData.corruption_multiplier_rate) * delta
	#GlobalData.corruption_cur_level += ((darkness_multiplier_rate * GlobalData.max_flat_corruption_rate) * GlobalData.corruption_multiplier_rate) * delta * 60
	update_corruption_bar.emit()

func update_holding(holding):
	if !is_instance_valid(light_node) || is_holding == holding:
		return
		
	is_holding = holding
	light_node.visible = !light_node.visible
	$"AnimatedSprite2D/Light Area2D/CollisionShape2D".disabled = !$"AnimatedSprite2D/Light Area2D/CollisionShape2D".disabled
	GlobalData.freeze_light_timer = !GlobalData.freeze_light_timer
	$AnimatedSprite2D/Torch.visible = !$AnimatedSprite2D/Torch.visible
	$AnimatedSprite2D/Sword.visible = !$AnimatedSprite2D/Sword.visible

func take_damage(n : int, enemy_pos : Vector2):
	var enemy_damage = n
	knockback_vector = (position - enemy_pos) * knockback_force

	GlobalData.player_cur_health -= enemy_damage
	update_health_bar.emit()
	
	$AnimatedSprite2D.modulate = Color(1,0,0)
	
	if GlobalData.player_cur_health <= 0:
		GlobalData.game_over = true
		print("Game Over!")
	else:
		$ChangeColour.start()

func set_target_item():
	if target_item != null:
		target_item.glow(false)
	target_item = interactables_array[0]
	for n in range(1, interactables_array.size()):
		if self.position.distance_to(interactables_array[n].position) < self.position.distance_to(target_item.position):
			target_item = interactables_array[n];
	set_interact_tooltip(true)
	target_item.glow(true)

func set_interact_tooltip(show_tooltip : bool):
	interact_label.visible = show_tooltip
	interact_texture.visible = show_tooltip
	
	if show_tooltip:
		interact_label.text = target_item.action + " " + target_item.interactableName
		interact_texture.texture = target_item.keyTexture

func attack_enemies():
	#is_attacking = true
	#is_attacking = false #temp value because no animation to reset
	$AnimatedSprite2D/AttackArea/Hitbox.disabled = false
		
func _on_attack_area_body_entered(body):
	if body.is_in_group("Hit"):
		body.take_damage(damage, position)

func add_interactable(area : Area2D):
	interactables_array.append(area)

func remove_interactable(area : Area2D):
	interactables_array.erase(area)
	area.glow(false)
	
	if interactables_array.size() <= 0:
		target_item = null
		set_interact_tooltip(false)

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Attack":
		is_attacking = false
		$AnimatedSprite2D/AttackArea/Hitbox.disabled = true
		$AnimatedSprite2D/Sword.visible = true
		$AnimatedSprite2D.play("Idle")
		
	if $AnimatedSprite2D.animation == "Attack_P1":
		$AnimatedSprite2D.play("Attack_P2")
		attack_enemies()
	elif $AnimatedSprite2D.animation == "Attack_P2":
		is_attacking = false
		$AnimatedSprite2D/AttackArea/Hitbox.disabled = true
		$AnimatedSprite2D/Sword.visible = true
		$AnimatedSprite2D.play("Idle")


func _on_change_colour_timeout():
	$AnimatedSprite2D.modulate = self_modulate
