extends Weapon

var weapon_enabled := false


func enable_weapon():
	set_process(true)
	weapon_enabled = true


func disable_weapon():
	set_process(false)
	weapon_enabled = false


func _process(delta):
	rotate(1.618033988749894 * 1.2 * delta)
