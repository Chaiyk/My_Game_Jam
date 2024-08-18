class_name Potion extends CharacterBody2D

var pot_speed = 400
var pot_grav = 500

func _physics_process(delta):
	velocity.y += pot_grav * delta
	move_and_slide()


func throw_potion(start_position, start_angle):
	position = start_position
	rotation = start_angle
	velocity = Vector2(pot_speed, 0).rotated(start_angle)

func break_potion():
	self.queue_free()
	pass
