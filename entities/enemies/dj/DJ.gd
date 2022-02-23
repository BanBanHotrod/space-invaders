extends Enemy

enum BossStates {
	DEFAULT,
	LASER_ATTACK,
	VINYL_ATTACK,
}

export(float) var entrance_speed = 35

onready var laser_weapon = $WeaponLaser
onready var vinyl_weapon = $WeaponVinyl
onready var laser_weapon_timer = $LaserWeaponTimer
onready var vinyl_weapon_timer = $VinylWeaponTimer

var current_boss_state = BossStates.DEFAULT
var in_position := false


func _ready():
	assert(laser_weapon != null)
	assert(vinyl_weapon != null)
	assert(laser_weapon_timer != null)
	assert(vinyl_weapon_timer != null)

	invincible = true

	Global.root.boss_health_bar_parent.show()


func _process(delta):
	if position.y < 100:
		position += Vector2(0, entrance_speed) * delta
	elif not in_position and position.y >= 100:
		invincible = false
		in_position = true
		animated_sprite.play()
		laser_weapon.enable_weapon()
		laser_weapon_timer.start()


func die(killed_by_player = false):
	Global.root.boss_health_bar_parent.hide()
	disable_collision()
	hide()
	queue_free()
	emit_signal("enemy_destroyed", self, killed_by_player)

	if pickup != null:
		var pickup_instance = pickup.instance()

		pickup_instance.position = position
		Global.root.spawn_instance(pickup_instance)


func take_damage(damage):
	if invincible:
		return

	health -= damage

	if health <= 0:
		die(true)

	modulate.g = 0.5
	modulate.b = 0.5

	$DamageCooldownTimer.start()
	collision_shape_2d.set_deferred("disabled", true)

	Global.root.boss_health_bar.rect_scale.x = health / total_health


func attack():
	if vinyl_weapon.weapon_enabled:
		vinyl_weapon.attack()


func _on_WeaponCooldownTimer_timeout():
	if in_position:
		attack()

	weapon_cooldown_timer.start()


func _on_LaserWeaponTimer_timeout():
	if in_position:
		vinyl_weapon_timer.start()
		weapon_cooldown_timer.start()
		laser_weapon.disable_weapon()
		vinyl_weapon.enable_weapon()


func _on_VinylWeaponTimer_timeout():
	if in_position:
		laser_weapon_timer.start()
		weapon_cooldown_timer.stop()
		vinyl_weapon.disable_weapon()
		laser_weapon.enable_weapon()
