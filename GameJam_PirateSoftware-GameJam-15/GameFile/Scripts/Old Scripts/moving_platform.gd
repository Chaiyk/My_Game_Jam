extends Path2D

@export var loop_path = true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var pathing = $PathFollow2D
@onready var animation = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	if !loop_path:
		animation.play("Move")
		animation.speed_scale = speed_scale
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pathing.progress += speed
