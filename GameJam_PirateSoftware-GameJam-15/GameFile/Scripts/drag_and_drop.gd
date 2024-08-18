extends TextureRect

@export var material_name : String

func _get_drag_data(at_position):
	var data_block = set_data_block()
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(50,50)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	print(texture)
	
	return data_block
	
func _can_drop_data(at_position, data):
	return data is Dictionary
	
func _drop_data(at_position, data):
	print(data)
	print(material_name)
	texture = data.texture_ref

func set_data_block():
	var dict = {}
	dict.mat_name = material_name
	dict.texture_ref = texture
	
	return dict
