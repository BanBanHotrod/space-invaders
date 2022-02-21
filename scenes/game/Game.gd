extends Node2D
class_name Game

var current_player = null
var players := []

onready var player_brandon = $Players/PlayerBrandon
onready var player_carro = $Players/PlayerCarro
onready var player_conrad = $Players/PlayerConrad
onready var player_kyle = $Players/PlayerKyle
onready var ui_brandon_skull = $CanvasLayer/UI/PlayerBrandonSkull
onready var ui_carro_skull = $CanvasLayer/UI/PlayerCarroSkull
onready var ui_conrad_skull = $CanvasLayer/UI/PlayerConradSkull
onready var ui_kyle_skull = $CanvasLayer/UI/PlayerKyleSkull
onready var announcer = $CanvasLayer/Announcer
onready var music_player = $MusicPlayer
onready var boss_health_bar_parent = $CanvasLayer/UI/BossHealthBar
onready var boss_health_bar = $CanvasLayer/UI/BossHealthBar/HealthBarBoss

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

	boss_health_bar_parent.hide()

	Global.root = self
	Global.emit_signal("root_initialized")

	players.append(player_brandon)
	players.append(player_carro)
	players.append(player_conrad)
	players.append(player_kyle)

	for player in players:
		player.despawn()

	current_player = player_conrad
	current_player.spawn()

	randomize()

	player_brandon.connect("player_died", self, "_on_Brandon_died")
	player_carro.connect("player_died", self, "_on_Carro_died")
	player_conrad.connect("player_died", self, "_on_Conrad_died")
	player_kyle.connect("player_died", self, "_on_Kyle_died")


func _process(_delta):
	process_input()


func respawn_player():
	if current_player.total_lives > 0:
		current_player.spawn()
		current_player.enable_grace()
	else:
		var next_player = get_next_player()

		if next_player != null:
			next_player.spawn()
			next_player.enable_grace()
		else:
			var return_value := get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

			if return_value != OK:
				print("Error changing scene:", return_value)
				get_tree().quit()

		current_player = next_player


func get_next_player():
	for player in players:
		if player.total_lives > 0:
			return player

	return null


func process_input():
	if not Global.controls:
		return

	if Input.is_action_pressed("action_attack"):
		emit_signal("input_attack_start")

	if Input.is_action_just_released("action_attack"):
		emit_signal("input_attack_stop")

	if Input.is_action_pressed("ui_cancel"):
		var result_value = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

		if result_value != OK:
			get_tree().quit()


func set_current_player(player):
	current_player.weapon.attack_stop()
	current_player.despawn()
	current_player = player
	current_player.spawn()
	print("current player", current_player)


func announce_wave(wave_number, title):
	announcer.announce_wave(wave_number, title)


func _on_Brandon_died():
	ui_brandon_skull.show()


func _on_Carro_died():
	ui_carro_skull.show()


func _on_Conrad_died():
	ui_conrad_skull.show()


func _on_Kyle_died():
	ui_kyle_skull.show()
