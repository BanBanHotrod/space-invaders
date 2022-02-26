extends Weapon

onready var overheat_timer = $OverheatTimer

export(Array, float) var fire_rate_levels
export(Array, PackedScene) var projectile_levels
export(int) var max_temperature := 10000

var current_level := 0
var overheat_time := 10
var overheated := false
var temperature := 0
var temperature_gain := 1000
var temperature_loss := 2000
var temperature_overheat_loss := 1000

signal weapon_temperature_changed(temperature, max_temperature)


func _ready():
	._ready()

	if fire_rate_levels.size() > 0:
		set_fire_rate(fire_rate_levels[current_level])


func _process(delta):
	if overheated:
		temperature -= int(temperature_overheat_loss * delta)
	else:
		temperature -= int(temperature_loss * delta)
	emit_signal("weapon_temperature_changed", temperature, max_temperature)

	if temperature <= 0:
		if overheated:
			overheated = false

		temperature = 0


func _spawn_projectile():
	if projectile_levels.size() == 0:
		._spawn_projectile()
		return

	var new_projectile = projectile_levels[Global.weapon_level].instance()

	Global.root.spawn_instance(new_projectile)
	new_projectile.position = global_transform.origin


func set_level(level):
	current_level = level

	if current_level < fire_rate_levels.size():
		set_fire_rate(fire_rate_levels[current_level])


func upgrade():
	if current_level >= projectile_levels.size() - 1:
		return

	Global.weapon_level += 1

	if Global.weapon_level >= 12:
		Global.weapon_level = 11

	set_level(current_level + 1)


func attack():
	if cooldown > 0.0:
		return

	if overheated:
		return

	temperature += 1000

	if temperature >= max_temperature:
		overheated = true
		temperature = max_temperature

	emit_signal("weapon_temperature_changed", temperature, max_temperature)

	.attack()
