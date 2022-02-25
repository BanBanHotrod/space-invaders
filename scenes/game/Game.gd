extends Node2D
class_name Game

var current_player = null
var players := []

onready var player_brandon = $Players/PlayerBrandon
onready var player_carro = $Players/PlayerCarro
onready var player_conrad = $Players/PlayerConrad
onready var player_kyle = $Players/PlayerKyle
onready var players_root = $Players
onready var ui_brandon_skull = $HUD/UI/PlayerBrandonSkull
onready var ui_carro_skull = $HUD/UI/PlayerCarroSkull
onready var ui_conrad_skull = $HUD/UI/PlayerConradSkull
onready var ui_kyle_skull = $HUD/UI/PlayerKyleSkull
onready var announcer = $HUD/Announcer
onready var music_player = $MusicPlayer
onready var boss_health_bar_parent = $HUD/UI/BossHealthBar
onready var boss_health_bar = $HUD/UI/BossHealthBar/HealthBarBoss
onready var enemy_effect = $Effects/EnemyEffect
onready var player_effect = $Effects/PlayerEffect
onready var asteroid_effect = $Effects/AsteroidEffect
onready var points_effect = $Effects/PointsEffect
onready var pause_popup = $PauseMenu/Popup
onready var ui = $HUD/UI
onready var instances_root = $Instances
onready var debug_event_text = $HUD/UI/DebugEvent

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
	assert(instances_root != null)

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
		player._connect_signals()
		player.despawn()

	current_player = players[random_player_index]
	current_player.spawn()

	randomize()

	player_brandon.connect("player_died", self, "_on_Brandon_died")
	player_carro.connect("player_died", self, "_on_Carro_died")
	player_conrad.connect("player_died", self, "_on_Conrad_died")
	player_kyle.connect("player_died", self, "_on_Kyle_died")

	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")


func _process(_delta):
	process_input()


func _input(event):
	if event:
		print(event.as_text())
		debug_event_text.text = event.as_text()


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
			Global.reset()

			var return_value := get_tree().change_scene("res://scenes/main_menu/MainMenu.tscn")

			if return_value != OK:
				print("Error changing scene:", return_value)
				get_tree().quit()

		current_player = next_player


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


func process_input():
	if not Global.controls:
		return

	if Input.is_action_pressed("action_attack"):
		emit_signal("input_attack_start")

	if Input.is_action_just_released("action_attack"):
		emit_signal("input_attack_stop")

	if Input.is_action_pressed("ui_cancel"):
		Global.reset()
		_show_pause_menu()


func set_current_player(player):
	current_player.weapon.attack_stop()
	current_player.despawn()
	current_player = player
	current_player.spawn()

	if current_player.total_lives <= 0:
		current_player.total_lives = 1


func announce_wave(wave_number, title):
	announcer.announce_wave(wave_number, title)


func _hide_entities():
	instances_root.hide()
	ui.hide()
	announcer.hide()
	players_root.hide()


func _show_entities():
	instances_root.show()
	ui.show()
	players_root.show()


func _hide_pause_menu():
	_show_entities()
	pause_popup.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _show_pause_menu():
	_hide_entities()
	pause_popup.show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Brandon_died():
	ui_brandon_skull.show()


func _on_Carro_died():
	ui_carro_skull.show()


func _on_Conrad_died():
	ui_conrad_skull.show()


func _on_Main_Menu_pressed():
	print("high scores: ", Global.high_scores)
	if not Global.first_launch and Global.total_score > 0:
		Global.add_high_score(Global.total_score)

	Global.save_game()
	get_tree().quit()


func _on_Resume_pressed():
	_hide_pause_menu()


func _on_Kyle_died():
	ui_kyle_skull.show()


func spawn_instance(scene_instance):
	instances_root.add_child(scene_instance)
