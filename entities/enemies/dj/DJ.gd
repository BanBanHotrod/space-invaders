extends Enemy

enum BossStates {
	DEFAULT,
	SUMMON_UFOS,
	LASER_ATTACK,
	VINYL_ATTACK,
}

export(float) var entrance_speed = 35

onready var ufo_weapon = $WeaponUFO
onready var laser_weapon = $WeaponLaser
onready var vinyl_weapon = $WeaponVinyl

var current_boss_state = BossStates.DEFAULT
var in_position := false


func _ready():
	assert(ufo_weapon != null)
	assert(laser_weapon != null)
	assert(vinyl_weapon != null)

	invincible = true


func _process(delta):
	if position.y < 100:
		position += Vector2(0, entrance_speed) * delta
	elif not in_position and position.y >= 100:
		invincible = false
		in_position = true
		weapon_cooldown_timer.wait_time = 0.01
		weapon_cooldown_timer.start()
		animated_sprite.play()
	Global.root.boss_health_bar_parent.show()


func die(killed_by_player = false):
	Global.root.boss_health_bar_parent.hide()
	pass


func take_damage(damage):
	.take_damage(damage)

	Global.root.boss_health_bar.rect_scale.x = health / total_health


func attack():
	# TODO: laser weapon
	if not laser_weapon.weapon_enabled:
		laser_weapon.enable_weapon()


#vinyl_weapon.attack()


func _on_WeaponCooldownTimer_timeout():
	if position.y > 0:
		attack()

	weapon_cooldown_timer.start()
