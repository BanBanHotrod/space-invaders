extends KinematicBody2D
class_name Player

signal player_died

export(int) var total_lives = 1
export(PackedScene) var death_effect

onready var weapon = $Weapon
onready var audio_stream_player = $AudioStreamPlayer
onready var collision_shape_2d_cockpit = $CollisionShape2DCockpit
onready var collision_shape_2d_wings = $CollisionShape2DWings
onready var grace_timer = $GraceTimer

var previous_position = null
var spawned := false
var grace := false


func _ready():
	assert(weapon != null)
	assert(audio_stream_player != null)
	assert(collision_shape_2d_cockpit != null)
	assert(collision_shape_2d_wings != null)
	assert(grace_timer != null)
	assert(death_effect != null)

	previous_position = position

	var return_value := Global.connect("root_initialized", self, "_on_root_initialized")
	if return_value != OK:
		print("Error connecting to signal:", return_value)


func _connect_signals():
	Global.root.connect("input_attack_start", self, "_on_attack_start")
	Global.root.connect("input_attack_stop", self, "_on_attack_stop")


func _disconnect_signals():
	Global.root.disconnect("input_attack_start", self, "_on_attack_start")
	Global.root.disconnect("input_attack_stop", self, "_on_attack_stop")


func _physics_process(_delta):
	if Global.controls:
		move_to_cursor()


func die():
	weapon.attack_stop()

	total_lives -= 1

	var death_effect_instance = death_effect.instance()

	Global.root.add_child(death_effect_instance)
	death_effect_instance.position = position

	collision_shape_2d_cockpit.set_deferred("disabled", true)
	collision_shape_2d_wings.set_deferred("disabled", true)

	despawn()

	emit_signal("player_died")


func upgrade_weapon():
	weapon.upgrade()


func move_to_cursor():
	var direction := get_global_mouse_position() - position
	var collision := move_and_collide(direction)

	if not grace and collision:
		var collider := collision.collider

		if collider.is_in_group("enemy"):
			die()
			collider.die()

		if collider.is_in_group("projectile"):
			die()
			collider.die()


func teleport_to_cursor():
	position = get_global_mouse_position()


func _on_attack_start():
	weapon.attack_start()


func _on_attack_stop():
	weapon.attack_stop()


func spawn():
	show()
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	enable_collisions()
	_connect_signals()


func despawn():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	disable_collisions()
	_disconnect_signals()


func enable_collisions():
	collision_shape_2d_cockpit.set_deferred("disabled", false)
	collision_shape_2d_wings.set_deferred("disabled", false)


func disable_collisions():
	collision_shape_2d_cockpit.set_deferred("disabled", true)
	collision_shape_2d_wings.set_deferred("disabled", true)


func enable_grace():
	grace = true
	grace_timer.start()
	modulate.a = 0.5
	disable_collisions()


func disable_grace():
	grace = false
	modulate.a = 1.0
	enable_collisions()


func _on_GraceTimer_timeout():
	disable_grace()
