extends Node2D

onready var audio_stream_player = $AudioStreamPlayer
onready var camera_2d = $Camera2D
onready var timer = $Timer
onready var score_update_timer = $ScoreUpdateTimer
onready var title = $VBoxContainer/HBoxContainer/Title

var first_launch := true
var in_position := false
var camera_velocity := Vector2(0, 100)


func _ready():
	assert(audio_stream_player != null)
	assert(camera_2d != null)
	assert(timer != null)
	assert(score_update_timer != null)
	assert(title != null)

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	Global.reset()
	Global.load_game()
	audio_stream_player.play()
	camera_2d.position.y = -2484
	in_position = false
	score_update_timer.start()
	_on_ScoreUpdateTimer_timeout()


func _input(_event):
	if Input.is_action_just_pressed("ui_select"):
		if not in_position:
			camera_2d.position.y = 360
			in_position = true
		else:
			_on_Start_pressed()


func _process(delta):
	if not in_position:
		if camera_2d.position.y < -360:
			camera_2d.position += camera_velocity * delta
		else:
			in_position = true
			timer.start()


func _on_Start_pressed():
	Global.total_score = 0
	audio_stream_player.stop()

	if true or Global.first_launch:
		Global.first_launch = false
		var return_value = get_tree().change_scene("res://scenes/intro_cutscene/IntroCutscene.tscn")
		if return_value != OK:
			print("Error changing scene:", return_value)
			get_tree().quit()
	else:
		Global.first_launch = false
		var return_value = get_tree().change_scene("res://scenes/game/Game.tscn")
		if return_value != OK:
			print("Error changing scene:", return_value)
			get_tree().quit()


func _on_Quit_pressed():
	audio_stream_player.stop()
	get_tree().quit()


func _on_Timer_timeout():
	camera_2d.position.y = 360


func _on_ScoreUpdateTimer_timeout():
	title.text = "High Scores"

	Global.high_scores.invert()
	Global.load_game()

	for high_score in Global.high_scores:
		title.text += "\n" + high_score.name + " " + str(high_score.score)
