extends ColorRect

@export var dialog_resources : Resource

var finished = false

func _ready():
	var text_speed = 0.05
	$Timer.wait_time = text_speed
	next_sentence()

func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		if finished:
			next_sentence()
		else:
			$Dialog.visible_characters = len($Dialog.text)

func next_sentence():
	var dialog = dialog_resources.get_internal_dialogue()
	
	if !dialog:
		get_tree().paused = false
		queue_free()
		print("test")
		return
	
	$Dialog.bbcode_text = dialog;
	
	$Dialog.visible_characters = 0
	finished = false
	
	while $Dialog.visible_characters < len($Dialog.text):
		$Dialog.visible_characters += 1
		
		$Timer.start()
		await $Timer.timeout
	finished = true
