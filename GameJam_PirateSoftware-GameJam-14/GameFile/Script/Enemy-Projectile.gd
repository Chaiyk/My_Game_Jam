extends CharacterBody2D

@export var SPEED = 100
@export var enemy_health = 3
var arrow_projectile = preload("res://Scene/arrow_projectile.tscn")

var player_chase = false
var player_attack = false
var player = null

var damage = 5

var attack_body = null

var knockback_vector = Vector2.ZERO
var knockback_force = 1

var proj_speed = 100
var delay = 2
var shotDelay

func _ready():
	shotDelay = delay

func _physics_process(delta):
	if player_chase and !GlobalData.game_over:
		$Bow.look_at(player.get_node("CollisionShape2D").global_position)
		if player.global_position.x < $Bow.global_position.x:
			$Bow.flip_v = true
		else:
			$Bow.flip_v = false
		$AnimatedSprite2D.play("Walk")
		velocity = global_position.direction_to(player.global_position)
		
		get_shot_timer(delta)
		
		if player.position.x - global_position.x < 0:
			$AnimatedSprite2D.scale.x = 1
		else:
			$AnimatedSprite2D.scale.x = -1
		
		if player_attack:
			velocity = Vector2.ZERO
			print(global_position.y - player.position.y)
			if global_position.y - player.position.y > 10:
				$AnimatedSprite2D.play("Attack_Up")
			elif global_position.y - player.position.y < -50:
				$AnimatedSprite2D.play("Attack_Down")
			else:
				$AnimatedSprite2D.play("Attack_Front")
		
		move_and_collide((velocity + knockback_vector) * SPEED * delta)
		knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.5)
	else:
		$AnimatedSprite2D.stop()

func get_shot_timer(delta):
	if	shotDelay < delay:
			shotDelay += delta

	if shotDelay >= delay and player_attack:
		shotDelay = 0
		shoot_projectile()

func shoot_projectile():
	var b = arrow_projectile.instantiate()
	b.start($Bow/Muzzle.global_position, $Bow.rotation)
	get_tree().root.add_child(b)

func _on_detection_zone_body_entered(body):
	if body.name == "Player":
		print("detected player")
		player = body
		player_chase = true

func _on_detection_zone_body_exited(_body):
	player = null
	player_chase = false

func _on_attack_zone_body_entered(body):
	if body.name == "Player":
		print("attack mode")
		attack_body = body
		player_attack = true
		print("On")

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		player_attack = false
	
#func _on_tts_timeout():
	#if attack_body && attack_body.get_name() == "Player":
		#shoot_projectile(attack_body)
		##var damage = 1
		##attack_body.take_damage(damage, position)
		##timer_called = false
	
func take_damage(n :int, player_pos :Vector2):
	var player_damage = n
	knockback_vector = (global_position - player_pos) * knockback_force
	enemy_health -= player_damage
	$AnimatedSprite2D.modulate = Color(1,0,0)
	
	$"Sound Effect/Hit".play()
	
	if enemy_health <= 0:
		queue_free()
	else:
		print(enemy_health)
		$ChangeColour.start()
		
func _on_change_colour_timeout():
	$AnimatedSprite2D.modulate = self_modulate
