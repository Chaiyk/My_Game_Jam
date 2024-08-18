extends Interactable

var hud_ref

func _ready():
	hud_ref = get_node("/root/Main/CanvasLayer/Hud")

func interact(body):
	GlobalData.keys += 1
	print("key collected!")
	print(GlobalData.keys)
	hud_ref.set_keys_collected()
	#play Sound Effect
	$"Sound Effect/Pick Up_Key".play()
	await $"Sound Effect/Pick Up_Key".finished
	
	super.interact(body)
	super.remove()
