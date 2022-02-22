extends Node2D
class_name Weapon

export(float) var fire_rate := 1.0
export(PackedScene) var projectile

onready var audio_stream_player = $AudioStreamPlayer

var cooldown := 0.0
var attacking := false

onready var cooldown_limit := 0.0


func _ready():
	assert(audio_stream_player != null)

	cooldown_limit = 1.0 / fire_rate


func _process(delta):
	if cooldown > 0.0:
		cooldown -= delta

	if attacking:
		attack()


func attack():
	if cooldown > 0.0:
		return

	audio_stream_player.play()

	_spawn_projectile()

	cooldown = cooldown_limit


func attack_start():
	attacking = true


func attack_stop():
	attacking = false


func set_fire_rate(new_fire_rate):
	fire_rate = new_fire_rate
	cooldown_limit = 1.0 / new_fire_rate


func _spawn_projectile():
	var new_projectile = projectile.instance()

	Global.root.add_child(new_projectile)
	new_projectile.rotation = rotation
	new_projectile.position = global_position
