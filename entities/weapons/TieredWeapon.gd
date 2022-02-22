extends Weapon

export(Array, float) var fire_rate_levels
export(Array, PackedScene) var projectile_levels

var current_level := 0


func _ready():
	._ready()

	if fire_rate_levels.size() > 0:
		set_fire_rate(fire_rate_levels[current_level])


func _spawn_projectile():
	if projectile_levels.size() == 0:
		._spawn_projectile()
		return

	var new_projectile = projectile_levels[Global.weapon_level].instance()

	Global.root.add_child(new_projectile)
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
