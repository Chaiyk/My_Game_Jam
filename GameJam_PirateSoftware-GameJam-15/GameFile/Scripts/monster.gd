class_name monster 
extends CharacterBody2D

@export var mon_speed : float = 100
@export var mon_atk : float = 1
@export var mon_health : float = 5
@export var mon_def : float = 5
@export var mon_type : String
@export var mon_mana_cost : float

var hit_rate_timer #var for timer
var damage_taken
var exited_body : bool = true

func _ready():
	#---Hit Box---#
	#Create Hit Box Signal
	var hit_box = get_node("Hit_Box")
	hit_box.connect("body_entered", _on_body_entered)
	hit_box.connect("body_exited", _on_body_exited)
	
	#---Hit Rate Timer---#
	#Create Timer	
	hit_rate_timer = Timer.new()
	add_child(hit_rate_timer)
	hit_rate_timer.name = "Hit_Rate"
	hit_rate_timer.wait_time = 0.5 #Attack Speed
	
	#Create Signal
	hit_rate_timer.connect("timeout", _on_timeout)

func _physics_process(delta):
	
	if exited_body:
		if mon_type == "Friendly":
			velocity.x = 1
		elif mon_type == "Enemy":
			velocity.x = -1
	else:
		velocity = Vector2.ZERO

	move_and_collide(velocity * mon_speed * delta)

func _on_body_entered(body):
	print(body)
	if body.mon_type == "Friendly" && mon_type == "Enemy":
		exited_body = false
		if (body.has_method("ft_take_dmg")):
			body.ft_take_dmg(mon_atk)
	elif body.mon_type == "Enemy" && mon_type == "Friendly":	
		exited_body = false
		if (body.has_method("ft_take_dmg")):
			body.ft_take_dmg(mon_atk)

func _on_body_exited(body: Node2D):
	hit_rate_timer.stop()
	exited_body = true

func ft_take_dmg(damage):
	hit_rate_timer.start()
	damage_taken = damage

func _on_timeout():
	print(mon_type)
	mon_health -= (damage_taken - mon_def)
	print("Current Health: ", mon_health)
	if mon_health <= 0:
		queue_free() #Delete Node
