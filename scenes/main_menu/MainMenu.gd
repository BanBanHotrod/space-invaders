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

	Global.load_game()
	audio_stream_player.play()

	if false and first_launch:
		camera_2d.position.y = -2484
	else:
		in_position = true

	if not Global.first_launch and Global.total_score > 0:
		Global.add_high_score(Global.total_score)

	score_update_timer.start()
	_on_ScoreUpdateTimer_timeout()


func _input(event):
	if Input.is_action_pressed("ui_select"):
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

	if false and Global.first_launch:
		Global.first_launch = false
		Global.save_game()
		var return_value = get_tree().change_scene("res://scenes/intro_cutscene/IntroCutscene.tscn")
		if return_value != OK:
			print("Error changing scene:", return_value)
			get_tree().quit()
	else:
		Global.first_launch = false
		Global.save_game()
		var return_value = get_tree().change_scene("res://scenes/game/Game.tscn")
		if return_value != OK:
			print("Error changing scene:", return_value)
			get_tree().quit()


func _on_Quit_pressed():
	if not Global.first_launch and Global.total_score > 0:
		Global.add_high_score(Global.total_score)

	audio_stream_player.stop()
	Global.save_game()
	get_tree().quit()


func _on_Timer_timeout():
	camera_2d.position.y = 360


func _on_ScoreUpdateTimer_timeout():
	title.text = "High Scores"

	Global.high_scores.invert()

	for i in range(len(Global.high_scores)):
		title.text += "\n" + str(i + 1) + ". " + str(Global.high_scores[i])
