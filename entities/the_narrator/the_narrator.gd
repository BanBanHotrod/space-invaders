extends Node

enum EventType {
	SET_STARS_VISIBILITY,
	SET_STARS_SPEED,
	SET_STARS_DENSITY,
	SET_CONTROLS_ENABLED,
	CREATE_ASTEROIDS,
	CREATE_ENEMY,
	CREATE_FORMATION_BLOCK,
	ENTER_SHOP,
	SLEEP,
	ANNOUNCE_WAVE,
}


class ScriptEvent:
	var type = null
	var command = null
	var parameters = {}


onready var the_script_source := "res://the_script.cfg"
var the_script := []
var sleeping := false
var line_number := 0

export(Array, PackedScene) var enemies = []
export(Array, PackedScene) var formations = []
export(PackedScene) var asteroid


func _ready():
	var return_value = Global.connect("root_initialized", self, "_on_root_initialized")
	if return_value != OK:
		print("Error connecting to signal:", return_value)
		get_tree().quit()


func _on_root_initialized():
	load_the_script()
	narrate()
	Global.disconnect("root_initialized", self, "_on_root_initialized")
	Global.root.announcer.connect("announce_wave_completed", self, "_on_announce_wave_completed")


func load_the_script():
	load_file(the_script_source)


func load_file(file_path):
	var regex = RegEx.new()
	regex.compile('[^\\s"]+|"[^"]*"')

	var file = File.new()

	file.open(file_path, File.READ)

	while not file.eof_reached():
		var line: String = file.get_line()

		line = line.strip_edges()

		if line.ends_with(";"):
			line = line.substr(0, len(line) - 1)

		if line.begins_with("#"):
			continue

		var tokens = []

		for result in regex.search_all(line):
			tokens.append(result.get_string())

		if tokens.size() == 0:
			continue

		var script_event = create_script_event(tokens)

		the_script.append(script_event)


func create_script_event(tokens):
	var script_event = ScriptEvent.new()

	var type = null
	var command = tokens[0]
	var parameters = {}

	# TODO: argument validation

	if command == "stars":
		type = EventType.SET_STARS_VISIBILITY

		if tokens[1] == "true":
			parameters.visible = true
		else:
			parameters.visible = false

		parameters.visible = tokens[1] == "true"
	elif command == "stars_speed":
		assert(tokens.size() == 2)
		type = EventType.SET_STARS_SPEED
		parameters.speed = int(tokens[1])
	elif command == "stars_density":
		assert(tokens.size() == 2)
		type = EventType.SET_STARS_DENSITY
		assert(tokens.size() == 2)
		parameters.density = int(tokens[1])
	elif command == "controls":
		type = EventType.SET_CONTROLS_ENABLED
		assert(tokens.size() == 2)
		parameters.enabled = int(tokens[1])
	elif command == "asteroid":
		type = EventType.CREATE_ASTEROIDS
		assert(tokens.size() == 2)
		parameters.count = int(tokens[1])
	elif command == "enemy":
		type = EventType.CREATE_ENEMY
		assert(tokens.size() == 2)
		parameters.enemy = int(tokens[1])
	elif command == "formation_block":
		type = EventType.CREATE_FORMATION_BLOCK
		assert(tokens.size() == 5)
		parameters.formation = int(tokens[1])
		parameters.enemy = int(tokens[2])
		parameters.width = int(tokens[3])
		parameters.height = int(tokens[4])
	elif command == "sleep":
		type = EventType.SLEEP
		assert(tokens.size() == 2)
		parameters.time = int(tokens[1])
	elif command == "wave":
		type = EventType.ANNOUNCE_WAVE
		assert(tokens.size() == 2)
		parameters.title = tokens[1]

	script_event.type = type
	script_event.command = command
	script_event.parameters = parameters

	return script_event


func narrate():
	if line_number >= the_script.size():
		print("Warning: End of script reached")
		return

	var script_event = the_script[line_number]

	if script_event.type == EventType.SET_STARS_VISIBILITY:
		var visible = script_event.parameters.visible

		Global.set_stars_visibility(visible)
	elif script_event.type == EventType.SET_STARS_SPEED:
		var speed = script_event.parameters.speed

		Global.set_stars_speed(speed)
	elif script_event.type == EventType.SET_STARS_DENSITY:
		var density = script_event.parameters.density

		Global.set_stars_density(density)
	elif script_event.type == EventType.SET_CONTROLS_ENABLED:
		var enabled = script_event.parameters.enabled

		Global.set_controls_enabled(enabled)
	elif script_event.type == EventType.CREATE_ASTEROIDS:
		var count = script_event.parameters.count

		create_asteroids(count)
	elif script_event.type == EventType.CREATE_ENEMY:
		create_enemy(script_event)
	elif script_event.type == EventType.CREATE_FORMATION_BLOCK:
		create_formation_block(script_event)
	elif script_event.type == EventType.SLEEP:
		sleep(script_event)
	elif script_event.type == EventType.ANNOUNCE_WAVE:
		announce_wave(script_event)

	line_number += 1


func create_enemy(script_event):
	# TODO: simplify or remove this logic
	var enemy = script_event.parameters.enemy

	if enemies.size() <= enemy:
		return

	var enemy_instance = enemies[enemy].instance()

	enemy_instance.connect("enemy_destroyed", self, "_on_enemy_destroyed")
	enemy_instance.position.x = 640
	enemy_instance.position.y = -150

	Global.root.add_child(enemy_instance)


func create_formation_block(script_event):
	var formation = script_event.parameters.formation
	var enemy = script_event.parameters.enemy

	if formations.size() <= formation:
		print("Error: Formation size %s out of bounds" % formations.size())
		return

	if enemies.size() <= enemy:
		print("Error: Enemies size %s out of bounds" % enemies.size())
		return

	var formation_instance = formations[formation].instance()
	formation_instance.position.x = 640
	formation_instance.position.y = 0

	var width = script_event.parameters.width
	var height = script_event.parameters.height

	formation_instance.width = width
	formation_instance.height = height
	formation_instance.enemy = enemies[enemy]
	formation_instance.vertical_speed = 20.0
	formation_instance.horizontal_speed = 200.0

	formation_instance.connect("formation_cleared", self, "_on_formation_cleared")

	Global.root.add_child(formation_instance)
	formation_instance.create_formation()


func sleep(script_event):
	var time = script_event.parameters.time

	sleeping = true

	$Timer.wait_time = time

	if not $Timer.is_connected("timeout", self, "_on_sleep_complete"):
		var return_value = $Timer.connect("timeout", self, "_on_sleep_complete")

		if return_value != OK:
			print("Error connecting to signal:", return_value)
			get_tree().quit()

	$Timer.start()


func announce_wave(script_event):
	Global.wave_number += 1
	var title = script_event.parameters.title

	Global.root.announce_wave(Global.wave_number, title)
	Global.root.music_player.play_next()


func create_asteroids(count):
	for _i in count:
		var asteroid_instance = asteroid.instance()

		asteroid_instance.connect("asteroid_destroyed", self, "_on_asteroid_destroyed")

		Global.root.add_child(asteroid_instance)


func _on_sleep_complete():
	sleeping = false
	narrate()


func _on_formation_cleared():
	Global.enemy_health_multiplier += 1
	narrate()


func _on_announce_wave_completed():
	narrate()


func _on_enemy_destroyed(_destroyed_enemy, _destroyed_by_player):
	Global.enemy_health_multiplier += 1
	narrate()


func _on_asteroid_destroyed(new_asteroids):
	if len(new_asteroids) == 0:
		narrate()
		return

	for new_asteroid in new_asteroids:
		new_asteroid.connect("asteroid_destroyed", self, "_on_asteroid_destroyed")
