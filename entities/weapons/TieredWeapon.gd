extends Weapon

export(Array, PackedScene) var projectile_levels
export(float) var max_temperature := 1.0

var current_level := 0
var overheat_time := 10
var overheated := false
var temperature := 0.0
var temperature_gain := 2.0
var temperature_gain_manual := 0.2
var temperature_loss := 4
var temperature_overheat_loss := 1

signal weapon_temperature_changed(temperature, max_temperature)


func _ready():
	._ready()


func _process(delta):
	if attacking:
		temperature += temperature_gain * delta

		if temperature >= max_temperature:
			overheated = true
			temperature = max_temperature
	else:
		if overheated:
			temperature -= temperature_loss * delta
		else:
			temperature -= temperature_overheat_loss * delta

		if temperature <= 0:
			if overheated:
				overheated = false

			temperature = 0

	emit_signal("weapon_temperature_changed", temperature, max_temperature)


func _spawn_projectile():
	if projectile_levels.size() == 0:
		._spawn_projectile()
		return

	var new_projectile = projectile_levels[Global.weapon_level].instance()

	Global.root.spawn_instance(new_projectile)
	new_projectile.position = global_transform.origin


func set_level(level):
	current_level = level


func upgrade():
	if current_level >= projectile_levels.size() - 1:
		return

	Global.weapon_level += 1

	if Global.weapon_level >= 12:
		Global.weapon_level = 11

	set_level(current_level + 1)


func attack(first_attack = false):
	if first_attack:
		if manual_cooldown > 0.0:
			return
	elif cooldown > 0.0 or manual_cooldown > 0.0:
		return

	if overheated:
		return

	if first_attack:
		temperature += temperature_gain_manual

	emit_signal("weapon_temperature_changed", temperature, max_temperature)

	.attack(first_attack)
