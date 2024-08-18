extends CharacterBody2D

@export var SPEED = 300
@export var enemy_health = 5

var player_chase = false
var player_attack = false
var player = null
var timer_called = false

var attack_body = null

var knockback_vector = Vector2.ZERO
var knockback_force = 1

func _physics_process(delta):
	if player_chase and !GlobalData.game_over:
		$AnimatedSprite2D.play("Walk")
		velocity = global_position.direction_to(player.position)
		
		if player.position.x - global_position.x < 0:
			$AnimatedSprite2D.scale.x = 1
		else:
			$AnimatedSprite2D.scale.x = -1
		
		if global_position.distance_to(player.position) < 20:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.stop()
		move_and_collide((velocity + knockback_vector) * SPEED * delta)
		knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.5)
	else:
		$AnimatedSprite2D.stop()
		
	if player_attack and !timer_called:
		timer_called = true
		$AnimatedSprite2D/Attack_Zone/TTS.start()
	
func _on_detection_zone_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true

func _on_detection_zone_body_exited(_body):
	player = null
	player_chase = false

func _on_attack_zone_body_entered(body):
	if body.name == "Player":
		attack_body = body
		player_attack = true
		print("On")

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		attack_body = null
		player_attack = false
		timer_called = false
		$AnimatedSprite2D/Attack_Zone/TTS.stop()
	
func _on_tts_timeout():
	if attack_body && attack_body.get_name() == "Player":
		var damage = 1
		attack_body.take_damage(damage, global_position)
		timer_called = false

func take_damage(n :int, player_pos :Vector2):
	var player_damage = n
	knockback_vector = (global_position - player_pos) * knockback_force	
	enemy_health -= player_damage
	$AnimatedSprite2D.modulate = Color(1,0,0)
	
	#Play Sound Effect
	$"Sound Effect/Hit".play()
	await $"Sound Effect/Hit".finished
	
	if enemy_health <= 0:
		queue_free()
	else:
		print(enemy_health)
		$ChangeColour.start()

func _on_change_colour_timeout():
	$AnimatedSprite2D.modulate = self_modulate
