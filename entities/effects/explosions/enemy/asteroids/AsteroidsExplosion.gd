extends Node


func _on_AudioStreamPlayer_finished():
	queue_free()
