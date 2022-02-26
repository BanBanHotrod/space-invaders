extends Control

onready var video_player = $VideoPlayer


func _ready():
	assert(video_player != null)


func _input(_event):
	if Input.is_action_pressed("ui_select"):
		video_player.stop()
		_exit_scene()


func _on_VideoPlayer_finished():
	_exit_scene()


func _exit_scene():
	var return_value = get_tree().change_scene("res://scenes/game/Game.tscn")
	if return_value != OK:
		print("Error changing scene:", return_value)
		get_tree().quit()
