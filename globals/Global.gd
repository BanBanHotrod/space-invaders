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
var weapon_level := 0
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


func _save_game():
	var _save_game = File.new()

	_save_game.open("user://savegame.save", File.WRITE)

	_save_game.store_line(
		to_json(
			{
				"first_launch": first_launch,
				"high_scores": high_scores,
			}
		)
	)

	_save_game.close()


func load_game():
	var _save_game = File.new()

	if not _save_game.file_exists("user://savegame.save"):
		return

	_save_game.open("user://savegame.save", File.READ)

	if _save_game.get_position() >= _save_game.get_len():
		var dir = Directory.new()
		print("Warning: Save file is empty, deleting")
		dir.remove("user://savegame.save")

	while _save_game.get_position() < _save_game.get_len():
		var save_data = parse_json(_save_game.get_line())

		for save_key in save_data.keys():
			if save_key == "first_launch":
				first_launch = save_data[save_key]

			if save_key == "high_scores":
				high_scores = save_data[save_key]

	_save_game.close()


class HighScoreSorter:
	static func sort_ascending(a, b):
		if not a or not "score" in a:
			return b
		if not b or not "score" in b:
			return a
		if a and a.score > b.score:
			return true
		return false


func add_high_score(name):
	high_scores.append({"name": name, "score": total_score})
	high_scores.sort_custom(HighScoreSorter, "sort_ascending")

	while len(high_scores) > 5:
		high_scores.pop_front()

	_save_game()


func score_is_new_high():
	if high_scores.size() < 5:
		return true

	for high_score in high_scores:
		if total_score > high_score.score:
			return true

	return false
