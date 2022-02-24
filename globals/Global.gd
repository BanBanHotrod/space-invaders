extends Node

const SCORE_UNTIL_REWARD := 1000

var root
var total_lives := 4
var controls := true
var total_score := 0
var reward_progress := 0
var enemy_health_multiplier := 1
var wave_number := 0
var enemy_attack_chance := 1000  # roll amount (e.g. 100 = 1/100)
var weapon_level := 11
var high_scores := []
var first_launch := true

signal root_initialized
signal asteroids_destroyed


func add_score(score):
	total_score += score
	reward_progress += score

	if reward_progress >= SCORE_UNTIL_REWARD:
		add_lives(1)
		reward_progress = 0

	self.root.find_node("UI").find_node("Score").text = str(total_score)


func add_lives(lives):
	total_lives += lives


signal set_stars_visibility(visible)


func set_stars_visibility(visible: bool):
	emit_signal("set_stars_visibility", visible)


signal set_stars_speed(speed)


func set_stars_speed(speed: float):
	emit_signal("set_stars_speed", speed)


signal set_stars_density(density)


func set_stars_density(density: float):
	emit_signal("set_stars_density", density)


func set_controls_enabled(enabled: bool):
	controls = enabled


signal blackout_level(time)


func blackout_level(time: int):
	emit_signal("blackout_level", time)


signal create_asteroid(count)


func create_asteroid(count: int):
	emit_signal("create_asteroid", count)


func reset():
	total_lives = 4
	controls = true
	reward_progress = 0
	enemy_health_multiplier = 1
	wave_number = 0
	enemy_attack_chance = 1000


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

	if not first_launch:
		while len(Global.high_scores) > 5:
			Global.high_scores.pop_front()

		Global.high_scores.sort()

	save_game.store_line(
		to_json(
			{
				"first_launch": first_launch,
				"high_scores": Global.high_scores,
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

			if save_key == "high_scores":
				Global.high_scores = save_data[save_key]

	save_game.close()


func add_high_score(high_score):
	high_scores.append(high_score)
	high_scores.sort()

	while len(high_scores) > 5:
		high_scores.pop_front()
