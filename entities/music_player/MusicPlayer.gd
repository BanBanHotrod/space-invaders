extends Node

export(Array, AudioStream) var music_streams = []

onready var audio_stream_player = $AudioStreamPlayer
var current_stream = -1


func _ready():
	assert(audio_stream_player != null)


func play_next():
	audio_stream_player.stop()
	current_stream += 1

	if current_stream > music_streams.size() - 1:
		current_stream = 0

	audio_stream_player.stream = music_streams[current_stream]
	audio_stream_player.play()


func _on_AudioStreamPlayer_finished():
	audio_stream_player.stop()
	current_stream += 1
	audio_stream_player.stream = music_streams[current_stream]


func _on_Timer_timeout():
	audio_stream_player.play()
