extends Menu

var executed := false
var loop : int = 0
var stop : bool = false

func _process(_delta):
	idle_snake()
	
	if !waited:
		await get_tree().create_timer(wait_timer).timeout
	waited = true
	
	if !Input.is_anything_pressed() || executed:
		return
		
	executed = true
	print("Start Game")
	var new_scene = load(target_scene_path)
	var new_scene_instance = new_scene.instantiate()
	new_scene_instance.name = "GameInstance"
	get_parent().add_child(new_scene_instance)
	queue_free()

func idle_snake():
	if !stop:
		if loop == 5:
			$Title.set_text("AFK?")
		elif loop == 10:
			$Title.set_text("Hellooo?")
		elif loop >= 15:
			stop = true
			$Title.set_text("Anybody?")
	
	if $Sprite2D.position.x >= 110:
		if !stop:
			loop += 1
		$Sprite2D.position.x = 0
	else:
		$Sprite2D.position.x += 1
