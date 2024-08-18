extends CharacterBody2D

@export var speed = 200

func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()

func _on_hit_area_body_entered(body):
	var damage = 5
	if body.name == "Player":
		body.take_damage(damage, position)
		queue_free()
	elif body.is_in_group("Hit") and !self:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
