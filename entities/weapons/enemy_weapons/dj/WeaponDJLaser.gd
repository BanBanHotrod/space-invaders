extends Weapon

enum WeaponState {
	IDLE,
	SEEK_PLAYER,
	PREPARE_ATTACK,
	ATTACK,
}

onready var idle_timer = $IdleTimer
onready var seek_timer = $SeekTimer
onready var prepare_timer = $PrepareTimer
onready var attack_timer = $AttackTimer
onready var blink_timer = $BlinkTimer
onready var targeting_laser = $TargetingLaser

var weapon_state = WeaponState.IDLE
var weapon_enabled := false
var rotation_speed := 100.0


func _ready():
	assert(idle_timer != null)
	assert(seek_timer != null)
	assert(prepare_timer != null)
	assert(attack_timer != null)
	assert(blink_timer != null)
	assert(targeting_laser != null)

	targeting_laser.hide()

	set_process(false)


func enable_weapon():
	set_process(true)
	idle_timer.start()
	weapon_enabled = true


func disable_weapon():
	set_process(false)
	idle_timer.stop()
	seek_timer.stop()
	prepare_timer.stop()
	attack_timer.stop()
	weapon_enabled = false


func _process(delta):
	var player = Global.root.current_player

	if weapon_state == WeaponState.IDLE:
		# do nothing
		pass
	elif weapon_state == WeaponState.SEEK_PLAYER:
		targeting_laser.scale.x = 2.0
		turn_to_player(delta)

	elif weapon_state == WeaponState.PREPARE_ATTACK:
		# blink targeting laser
		pass
	elif weapon_state == WeaponState.ATTACK:
		attack()


func turn_to_player(delta):
	var player = Global.root.current_player
	var weapon_direction = Vector2.UP.rotated(rotation)
	var direction_to_player = player.global_position - global_position
	var angle_to_player = rad2deg(weapon_direction.angle_to(direction_to_player))

	if abs(angle_to_player) < 4:
		targeting_laser.scale.x = (
			global_position.distance_to(player.global_position)
			/ targeting_laser.texture.get_width()
		)
		look_at_player()
	elif angle_to_player < 0:
		rotate(-deg2rad(rotation_speed * delta))
	else:
		rotate(deg2rad(rotation_speed * delta))


func look_at_player():
	var player = Global.root.current_player

	if player != null:
		look_at(player.global_position)
		rotate(deg2rad(90))


func _on_IdleTimer_timeout():
	var player = Global.root.current_player

	if player != null:
		targeting_laser.show()
		weapon_state = WeaponState.SEEK_PLAYER
		seek_timer.start()
	else:
		idle_timer.start()


func _on_SeekTimer_timeout():
	weapon_state = WeaponState.PREPARE_ATTACK
	prepare_timer.start()
	blink_timer.start()


func _on_PrepareTimer_timeout():
	weapon_state = WeaponState.ATTACK
	targeting_laser.hide()
	attack_timer.start()


func _on_AttackTimer_timeout():
	weapon_state = WeaponState.IDLE
	idle_timer.start()
	rotation = deg2rad(180)


func _on_BlinkTimer_timeout():
	targeting_laser.modulate.a = 1.0
	blink_timer.start()
