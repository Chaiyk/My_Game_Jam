extends Area2D
class_name Interactable

@export var canInteract : bool
@export var canGlow : bool
@export var interactableName : String
@export var action : String
@export var keyTexture : Texture


func interact(_body):
	print(self.get_name())
	print(action)
	
func remove():
	queue_free()

func glow(show_glow : bool):
	if canGlow:
		$"Glow Sprite2D".visible = show_glow

func _on_body_entered(body):
	if body.get_name() == "Player":
		body.add_interactable(self)

func _on_body_exited(body):
	if body.get_name() == "Player":
		body.remove_interactable(self)
