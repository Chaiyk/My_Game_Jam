extends Control

var finished = false
var label_list 
var dialog_list
var label_counter = 0
var dialog_counter = 0
var label

func _ready():
	var text_speed = 0.05
	label_list = [$ColorRect/RichTextLabel, $ColorRect/RichTextLabel/RichTextLabel2]
	dialog_list = ["[center]Congratulations! You've survived![/center]",
					"[right][b][i][color=red]For now.[/color][/i][/b][/right]"]
	$ColorRect/Timer.wait_time = text_speed
	next_sentence()

func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if finished and label_counter == 0 and dialog_counter == 0:
			next_sentence()
		else:
			label.visible_characters = len(label.text)
	
	if label_counter == 1 and dialog_counter == 1:
		$ColorRect/Menu.modulate.a = 1

func next_sentence():
	var dialog = dialog_list[dialog_counter]
	label = label_list[label_counter]
	
	label.bbcode_text = dialog
	
	label.visible_characters = 0
	finished = false
	
	while label.visible_characters < len(label.text):
		label.visible_characters += 1
		
		$ColorRect/Timer.start()
		await $ColorRect/Timer.timeout
	finished = true
	label_counter += 1
	dialog_counter += 1
	
	if finished and label_counter == 1 and dialog_counter == 1:
		next_sentence()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scene/Menu.tscn")
