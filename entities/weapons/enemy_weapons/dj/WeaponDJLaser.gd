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


func _process(_delta):
	var player = Global.root.current_player

	if weapon_state == WeaponState.IDLE:
		pass
	elif weapon_state == WeaponState.SEEK_PLAYER:
		look_at_player()
		targeting_laser.scale.x = global_position.distance_to(player.global_position) / 400
		targeting_laser.global_position = lerp(global_position, player.global_position, 0.5)

	# draw targeting laser
	elif weapon_state == WeaponState.PREPARE_ATTACK:
		look_at_player()
		# blink targeting laser
		pass
	elif weapon_state == WeaponState.ATTACK:
		attack()


func look_at_player():
	var player = Global.root.current_player

	if player != null:
		look_at(player.position)
		rotate(deg2rad(90))


func _on_IdleTimer_timeout():
	var player = Global.root.current_player

	if player != null:
		targeting_laser.show()
		weapon_state = WeaponState.SEEK_PLAYER
		seek_timer.start()
		print("SEEK")
	else:
		idle_timer.start()
		print("IDLE")


func _on_SeekTimer_timeout():
	weapon_state = WeaponState.PREPARE_ATTACK
	prepare_timer.start()
	blink_timer.start()
	print("PREPARE")


func _on_PrepareTimer_timeout():
	targeting_laser.hide()
	weapon_state = WeaponState.ATTACK
	attack_timer.start()
	print("ATTACK")


func _on_AttackTimer_timeout():
	weapon_state = WeaponState.IDLE
	idle_timer.start()
	print("IDLE")


func _on_BlinkTimer_timeout():
	targeting_laser.modulate.a = 1.0
	blink_timer.start()
