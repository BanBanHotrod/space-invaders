extends Node2D
class_name Formation

signal formation_cleared

export(Array, PackedScene) var pickups = []
export(float) var entrance_speed := 50

var vertical_speed := 10.0
var horizontal_speed := 20.0
var width := 10
var height := 50
var enemy: PackedScene = null
var enemies := []
var total_enemies := 0
var horizontal_gap := 50
var vertical_gap := 80
var score_multiplier := 1
var velocity := Vector2.ZERO
var in_position := false
var in_position_height := 0


func _ready():
	set_process(false)


func _process(delta):
	if not in_position:
		if position.y < in_position_height:
			velocity = Vector2(0, entrance_speed)
		else:
			in_position = true
			velocity = Vector2(horizontal_speed, 0)
			for enemy_instance in enemies:
				enemy_instance.invincible = false
	else:
		if velocity.x > 0:
			if position.x + int(width / 2.0) * horizontal_gap >= get_viewport_rect().size.x:
				velocity.x *= -1
		elif velocity.x < 0:
			if position.x - int(width / 2.0) * horizontal_gap - horizontal_gap <= 0:
				velocity.x *= -1

	position += velocity * delta

	for enemy_instance in enemies:
		if is_instance_valid(enemy_instance):
			enemy_instance.position += velocity * delta


func create_formation():
	if enemy == null:
		print("Error: Formation enemy is null")
		return

	var pickup_x = 0
	var pickup_y = 0

	if width > 1:
		pickup_x = randi() % (width - 1)

	if height > 1:
		pickup_y = randi() % (height - 1)

	# this isn't fun
	# velocity = Vector2(
	# 	horizontal_speed + (10 * Global.wave_number), vertical_speed + (20 * Global.wave_number)
	# )

	for y in height:
		for x in width:
			var enemy_instance = enemy.instance()
			var screen_size = get_viewport_rect().size
			var formation_x_offset = int(screen_size.x / 2) - int((horizontal_gap * width) / 2.0)

			if y == pickup_y and x == pickup_x:
				var random_pickup = randi() % pickups.size()
				enemy_instance.pickup = pickups[random_pickup]

			enemy_instance.position.x = horizontal_gap * x + formation_x_offset
			enemy_instance.position.y = -vertical_gap * y
			enemy_instance.total_health = (
				enemy_instance.total_health
				* (Global.enemy_health_multiplier)
			)
			enemy_instance.health = enemy_instance.total_health
			enemy_instance.invincible = true

			enemies.append(enemy_instance)

			enemy_instance.connect("enemy_destroyed", self, "_on_enemy_destroyed")

			Global.root.spawn_instance(enemy_instance)

	total_enemies = enemies.size()
	score_multiplier = 1 + Global.wave_number

	var enemy_height = enemies[0].get_height()

	in_position_height = (vertical_gap * int(float(height) / 2.0)) + (vertical_gap * 1.5)
	set_process(true)


func _on_enemy_destroyed(destroyed_enemy, killed_by_player):
	if killed_by_player:
		Global.add_score(destroyed_enemy.score * score_multiplier)

	for existing_enemy in enemies:
		if existing_enemy == destroyed_enemy:
			var enemy_index = enemies.find(existing_enemy)

			enemies.remove(enemy_index)

			total_enemies -= 1

			if total_enemies <= 0:
				emit_signal("formation_cleared")


func _on_AggressionTimer_timeout():
	velocity.y = vertical_speed
