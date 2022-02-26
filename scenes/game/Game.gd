extends Node2D
class_name Game

var current_player = null
var players := []
var weapon_temperature := 0
var weapon_max_temperature := 0
var show_pause_menu := false
var selected_y_positions := [280, 650]
var selected_y_position := 0
var high_score_character_nodes := []
var high_score_characters := []
var high_score_name := ""
var high_score_character_set := [
	"_",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
]
var focused_high_score_character := 0
var show_high_score_menu := false

onready var player_brandon = $Instances/Players/PlayerBrandon
onready var player_carro = $Instances/Players/PlayerCarro
onready var player_conrad = $Instances/Players/PlayerConrad
onready var player_kyle = $Instances/Players/PlayerKyle
onready var players_root = $Instances/Players
onready var ui_brandon_skull = $HUD/UI/PlayerBrandonSkull
onready var ui_carro_skull = $HUD/UI/PlayerCarroSkull
onready var ui_conrad_skull = $HUD/UI/PlayerConradSkull
onready var ui_kyle_skull = $HUD/UI/PlayerKyleSkull
onready var announcer = $HUD/Announcer
onready var music_player = $MusicPlayer
onready var boss_health_bar_parent = $HUD/UI/BossHealthBar
onready var boss_health_bar = $HUD/UI/BossHealthBar/HealthBarBoss
onready var enemy_effect = $Instances/Effects/EnemyEffect
onready var player_effect = $Instances/Effects/PlayerEffect
onready var asteroid_effect = $Instances/Effects/AsteroidEffect
onready var points_effect = $Instances/Effects/PointsEffect
onready var pause_popup = $PauseMenu/Popup
onready var ui = $HUD/UI
onready var cookies = $Instances/Cookies
onready var debug_event_text = $HUD/UI/DebugEvent
onready var the_narrator = $TheNarrator
onready var instances_root = $Instances
onready var weapon_temperature_bar = $HUD/UI/WeaponTemperature/Value
onready var selected_menu_item = $PauseMenu/Popup/HBoxContainer/Container/Selected
onready var high_score_popup = $ScoreInput/Popup
onready var high_score_characters_node = $ScoreInput/Popup/VBoxContainer/Container/Characters
onready var blink_timer = $BlinkTimer

signal root_initialized
signal input_attack_start
signal input_attack_stop


func _ready():
	assert(player_brandon != null)
	assert(player_carro != null)
	assert(player_conrad != null)
	assert(player_kyle != null)
	assert(ui_brandon_skull != null)
	assert(ui_carro_skull != null)
	assert(ui_conrad_skull != null)
	assert(ui_kyle_skull != null)
	assert(announcer != null)
	assert(music_player != null)
	assert(boss_health_bar != null)
	assert(boss_health_bar_parent != null)
	assert(enemy_effect != null)
	assert(player_effect != null)
	assert(asteroid_effect != null)
	assert(points_effect != null)
	assert(pause_popup != null)
	assert(ui != null)
	assert(cookies != null)
	assert(the_narrator != null)
	assert(instances_root != null)
	assert(weapon_temperature_bar != null)
	assert(high_score_popup != null)
	assert(high_score_characters_node != null)
	assert(blink_timer != null)

	for character in high_score_characters_node.get_children():
		high_score_characters.append(0)
		high_score_character_nodes.append(character)

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	boss_health_bar_parent.hide()

	Global.root = self
	emit_signal("root_initialized")
	Global.emit_signal("root_initialized")

	players.append(player_brandon)
	players.append(player_carro)
	players.append(player_conrad)
	players.append(player_kyle)

	var random_player_index = randi() % 4

	for player in players:
		player.connect("weapon_temperature_changed", self, "_on_weapon_temperature_changed")
		player._connect_signals()
		player.despawn()

	current_player = players[random_player_index]
	current_player.spawn()

	randomize()

	player_brandon.connect("player_died", self, "_on_Brandon_died")
	player_carro.connect("player_died", self, "_on_Carro_died")
	player_conrad.connect("player_died", self, "_on_Conrad_died")
	player_kyle.connect("player_died", self, "_on_Kyle_died")
	the_narrator.connect("spawn_cookie", self, "_on_spawn_cookie")


func respawn_player():
	if current_player != null and current_player.total_lives > 0:
		current_player.spawn()
		current_player.enable_grace()
	else:
		var next_player = get_next_player()

		if next_player != null:
			next_player.spawn()
			next_player.enable_grace()
		else:
			if Global.score_is_new_high():
				show_high_score_menu = true
				high_score_popup.show()
			else:
				_show_pause_menu()
			Global.reset()
			blink_timer.start()
			return

		current_player = next_player


func _exit_to_menu():
	var return_value := get_tree().change_scene("res://scenes/main_menu/MainMenu.tscn")

	if return_value != OK:
		print("Error changing scene:", return_value)
		get_tree().quit()


func get_next_player():
	var has_remaining_players := false

	for player in players:
		if player.total_lives > 0:
			has_remaining_players = true
			break

	if not has_remaining_players:
		return null

	while 1:
		var random_player_index = randi() % players.size()
		var player = players[random_player_index]

		if player.total_lives > 0:
			return player


func _input(event):
	if not Global.controls:
		return

	if Input.is_action_pressed("action_attack"):
		emit_signal("input_attack_start")

	if Input.is_action_just_released("action_attack"):
		emit_signal("input_attack_stop")

	if not show_high_score_menu and Input.is_action_pressed("ui_cancel"):
		Global.reset()
		_show_pause_menu()

	if show_pause_menu:
		print("PAUSED")
		if Input.is_action_pressed("ui_focus_prev"):
			print("PREVIOUS")
			selected_y_position -= 1
			if selected_y_position < 0:
				selected_y_position = selected_y_positions.size() - 1
			selected_menu_item.rect_position.y = selected_y_positions[selected_y_position]

		if Input.is_action_pressed("ui_focus_next"):
			print("NEXT")
			selected_y_position += 1
			if selected_y_position >= selected_y_positions.size():
				selected_y_position = 0
			selected_menu_item.rect_position.y = selected_y_positions[selected_y_position]

		if Input.is_action_pressed("ui_select"):
			if selected_y_position == 0:
				_hide_pause_menu()
			elif selected_y_position == 1:
				_on_Main_Menu_pressed()

	elif show_high_score_menu:
		if Input.is_action_just_pressed("ui_left"):
			focused_high_score_character -= 1

			if focused_high_score_character < 0:
				focused_high_score_character = high_score_characters.size() - 1

			_show_character_nodes()
		if Input.is_action_just_pressed("ui_right"):
			focused_high_score_character += 1

			if focused_high_score_character > high_score_characters.size() - 1:
				focused_high_score_character = 0
			_show_character_nodes()
		if Input.is_action_just_pressed("ui_up"):
			high_score_characters[focused_high_score_character] += 1

			if (
				high_score_characters[focused_high_score_character]
				> high_score_character_set.size() - 1
			):
				high_score_characters[focused_high_score_character] = 0

			high_score_character_nodes[focused_high_score_character].text = high_score_character_set[high_score_characters[focused_high_score_character]]
			_show_character_nodes()
		if Input.is_action_just_pressed("ui_down"):
			high_score_characters[focused_high_score_character] -= 1

			if high_score_characters[focused_high_score_character] < 0:
				high_score_characters[focused_high_score_character] = (
					high_score_character_set.size()
					- 1
				)
			high_score_character_nodes[focused_high_score_character].text = high_score_character_set[high_score_characters[focused_high_score_character]]
			_show_character_nodes()
		if Input.is_action_pressed("ui_select"):
			_save_high_score()
			_exit_to_menu()


func set_current_player(player):
	var last_position = current_player.global_position
	var previous_player = current_player

	previous_player.weapon.attack_stop()
	previous_player.despawn()

	current_player = player
	current_player.spawn()
	current_player.global_position = last_position

	previous_player.global_position = players_root.global_position

	if current_player.total_lives <= 0:
		current_player.total_lives = 1


func announce_wave(wave_number, title):
	announcer.announce_wave(wave_number, title)


func _hide_entities():
	cookies.hide()
	instances_root.hide()
	ui.hide()
	announcer.hide()
	players_root.hide()


func _show_entities():
	cookies.show()
	instances_root.show()
	ui.show()
	players_root.show()


func _hide_pause_menu():
	show_pause_menu = false
	_show_entities()
	pause_popup.hide()
	instances_root.set_process(true)
	instances_root.set_physics_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _show_pause_menu():
	show_pause_menu = true
	_hide_entities()
	pause_popup.show()
	instances_root.set_process(false)
	instances_root.set_physics_process(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _show_character_nodes():
	for character_node in high_score_character_nodes:
		character_node.show()
	blink_timer.stop()
	blink_timer.start()


func _save_high_score():
	for character in high_score_characters:
		var character_text = high_score_character_set[character]
		high_score_name += character_text

	high_score_name = high_score_name.replace("_", " ")
	Global.add_high_score(high_score_name)


func _on_Brandon_died():
	player_brandon.global_position = players_root.global_position
	ui_brandon_skull.show()


func _on_Carro_died():
	player_carro.global_position = players_root.global_position
	ui_carro_skull.show()


func _on_Conrad_died():
	player_conrad.global_position = players_root.global_position
	ui_conrad_skull.show()


func _on_Kyle_died():
	player_kyle.global_position = players_root.global_position
	ui_kyle_skull.show()


func _on_Main_Menu_pressed():
	# get_tree().quit()
	Global.reset()
	_hide_pause_menu()

	var return_value := get_tree().change_scene("res://scenes/main_menu/MainMenu.tscn")

	if return_value != OK:
		print("Error changing scene:", return_value)
		get_tree().quit()


func _on_Resume_pressed():
	_hide_pause_menu()


func _on_weapon_temperature_changed(temperature, max_temperature):
	weapon_temperature = temperature
	weapon_max_temperature = max_temperature
	weapon_temperature_bar.rect_scale.x = float(temperature) / float(max_temperature)


func _on_spawn_cookie(position):
	cookies.spawn_cookie(position)


func spawn_instance(scene_instance):
	instances_root.add_child(scene_instance)


func print_debug(message):
	debug_event_text.text = message


func _on_BlinkTimer_timeout():
	if show_high_score_menu:
		var focused_node = high_score_character_nodes[focused_high_score_character]

		if focused_node.visible:
			focused_node.hide()
		else:
			focused_node.show()
