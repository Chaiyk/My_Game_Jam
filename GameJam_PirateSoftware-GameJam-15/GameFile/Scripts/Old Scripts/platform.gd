class_name Platform extends Node2D

@export var current_platform_type: = platform_type.default

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
enum platform_type {
	default,
	shadow,
	light,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_platform_type(current_platform_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_platform_type(type: platform_type) -> void:
	var static_body_2d: StaticBody2D = collision_shape_2d.get_parent()
	if current_platform_type == platform_type.default:
		static_body_2d.collision_layer = 1 | 2
		return
		
	current_platform_type = type
	static_body_2d.collision_layer = current_platform_type

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent() == self:
		return
	print("platform: " + body.name)
	pass # Replace with function body.
