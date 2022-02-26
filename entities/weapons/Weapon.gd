extends Node2D
class_name Weapon

export(float) var automatic_fire_rate := 1.0
export(float) var manual_fire_rate := 2.0
export(PackedScene) var projectile

onready var audio_stream_player = $AudioStreamPlayer

var cooldown := 0.0
var attacking := false
var manual_cooldown := 0.0
var cooldown_limit := 0.0
var manual_cooldown_limit := 0.0


func _ready():
	assert(audio_stream_player != null)

	cooldown_limit = 1.0 / automatic_fire_rate
	manual_cooldown_limit = 1.0 / manual_fire_rate


func _process(delta):
	if manual_cooldown > 0.0:
		manual_cooldown -= delta
		if manual_cooldown < 0:
			manual_cooldown = 0
	if cooldown > 0.0:
		cooldown -= delta
		if cooldown < 0:
			cooldown = 0


func attack(first_attack = false):
	attacking = true

	if first_attack:
		if manual_cooldown > 0.0:
			return
	elif cooldown > 0.0 or manual_cooldown > 0.0:
		return

	audio_stream_player.play()

	_spawn_projectile()

	manual_cooldown = manual_cooldown_limit
	cooldown = cooldown_limit


func attack_start():
	if attacking == false:
		attack(true)
	else:
		attack(false)


func attack_stop():
	attacking = false


func _spawn_projectile():
	var new_projectile = projectile.instance()

	Global.root.spawn_instance(new_projectile)
	new_projectile.rotation = rotation
	new_projectile.position = global_position
