extends Node2D

var prev_audio_name : String

func play(audio_name : String):
	var audio_stream = get_node(audio_name)
	if !audio_stream:
		print("audio stream not found")
		return
	if prev_audio_name:
		var prev_audio_stream = get_node(prev_audio_name)
		if prev_audio_stream:
			prev_audio_stream.stop()
	audio_stream.play()
	prev_audio_name = audio_name
