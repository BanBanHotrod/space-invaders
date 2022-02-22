extends Node2D

onready var audio_stream_player = $AudioStreamPlayer
onready var camera_2d = $Camera2D
onready var timer = $Timer

var first_launch := true
var in_position := false
var camera_velocity := Vector2(0, 100)


func _ready():
	assert(audio_stream_player != null)
	assert(camera_2d != null)
	assert(timer != null)

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	load_game()
	audio_stream_player.play()

	if first_launch:
		camera_2d.position.y = -2484
	else:
		in_position = true


func _process(delta):
	if not in_position:
		if camera_2d.position.y < -360:
			camera_2d.position += camera_velocity * delta
		else:
			in_position = true
			timer.start()


func _on_Start_pressed():
	audio_stream_player.stop()

	if first_launch:
		first_launch = false
		save_game()
		var return_value = get_tree().change_scene("res://scenes/intro_cutscene/IntroCutscene.tscn")
		if return_value != OK:
			print("Error changing scene:", return_value)
			get_tree().quit()
	else:
		pass
		var return_value = get_tree().change_scene("res://scenes/game/Game.tscn")
		if return_value != OK:
			print("Error changing scene:", return_value)
			get_tree().quit()


func _on_Quit_pressed():
	audio_stream_player.stop()
	save_game()
	get_tree().quit()


func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"first_launch": first_launch,
	}

	return save_dict


func save_game():
	var save_game = File.new()

	save_game.open("user://savegame.save", File.WRITE)

	save_game.store_line(
		to_json(
			{
				"first_launch": first_launch,
			}
		)
	)

	save_game.close()


func load_game():
	var save_game = File.new()

	if not save_game.file_exists("user://savegame.save"):
		return

	save_game.open("user://savegame.save", File.READ)

	if save_game.get_position() >= save_game.get_len():
		var dir = Directory.new()
		print("Warning: Save file is empty, deleting")
		dir.remove("user://savegame.save")

	while save_game.get_position() < save_game.get_len():
		var save_data = parse_json(save_game.get_line())

		for save_key in save_data.keys():
			if save_key == "first_launch":
				first_launch = save_data[save_key]

	save_game.close()


func _on_Timer_timeout():
	camera_2d.position.y = 360
