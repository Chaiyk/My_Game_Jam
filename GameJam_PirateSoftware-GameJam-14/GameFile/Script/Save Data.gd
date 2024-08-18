extends Resource
class_name first_time_playing

@export var first_time := true

func save(content):
	first_time = content

func load_data():
	GlobalData.first_time = first_time
