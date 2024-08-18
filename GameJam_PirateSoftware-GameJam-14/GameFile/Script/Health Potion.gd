extends Interactable

@export var heal_health : int = 15

func interact(body):
	print("Health Potion Used!")
	GlobalData.player_cur_health += heal_health
	body.update_health_bar.emit()
	
	#play Sound Effect
	$"Sound Effect/Pick Up_Potion".play()
	await $"Sound Effect/Pick Up_Potion".finished
	
	super.interact(body)
	super.remove()
