extends KinematicBody2D
class_name Player

signal player_died
signal weapon_temperature_changed(temperature, max_temperature)

export(int) var total_lives = 1
export(PackedScene) var death_effect

onready var weapon = $Weapon
onready var collision_shape_2d_cockpit = $CollisionShape2DCockpit
onready var collision_shape_2d_wings = $CollisionShape2DWings
onready var grace_timer = $GraceTimer

var previous_position = null
var spawned := false
var grace := false
var input_disabled := false
var joystick_speed := 500.0
var arcade_mode := true
var dead := true


func _ready():
	assert(weapon != null)
	assert(collision_shape_2d_cockpit != null)
	assert(collision_shape_2d_wings != null)
	assert(grace_timer != null)
	assert(death_effect != null)

	previous_position = position

	weapon.connect("weapon_temperature_changed", self, "_on_weapon_temperature_changed")


func _process(delta):
	process_input(delta)


func process_input(delta):
	if Input.is_action_pressed("move_left"):
		move_left(delta)

	if Input.is_action_pressed("move_right"):
		move_right(delta)

	if Input.is_action_pressed("move_up"):
		move_up(delta)

	if Input.is_action_pressed("move_down"):
		move_down(delta)


func _connect_signals():
	Global.root.connect("input_attack_start", self, "_on_attack_start")
	Global.root.connect("input_attack_stop", self, "_on_attack_stop")
	Global.root.connect("input_attack_once", self, "_on_attack_once")


func _physics_process(_delta):
	if Global.controls and not arcade_mode:
		move_to_cursor()


func die():
	if dead:
		return

	dead = true
	weapon.attack_stop()

	total_lives -= 1

	var death_effect_instance = death_effect.instance()

	Global.root.spawn_instance(death_effect_instance)
	death_effect_instance.global_position = global_position

	Global.root.player_effect.play()

	collision_shape_2d_cockpit.set_deferred("disabled", true)
	collision_shape_2d_wings.set_deferred("disabled", true)

	despawn()

	emit_signal("player_died")


func upgrade_weapon():
	weapon.upgrade()


func move_left(delta):
	var direction = Vector2(-1, 0)
	var collision = move_and_collide(direction * joystick_speed * delta)

	handle_collision(collision)
	handle_oob()


func move_right(delta):
	var direction = Vector2(1, 0)
	var collision = move_and_collide(direction * joystick_speed * delta)

	handle_collision(collision)
	handle_oob()


func move_up(delta):
	var direction = Vector2(0, -1)
	var collision = move_and_collide(direction * joystick_speed * delta)

	handle_collision(collision)
	handle_oob()


func move_down(delta):
	var direction = Vector2(0, 1)
	var collision = move_and_collide(direction * joystick_speed * delta)

	handle_collision(collision)
	handle_oob()


func handle_collision(collision):
	if not grace and collision:
		var collider = collision.collider

		if collider.is_in_group("boss"):
			die()

		if collider.is_in_group("enemy"):
			die()
			collider.die()

		if collider.is_in_group("projectile"):
			die()
			collider.die()

		if collider.is_in_group("points"):
			Global.add_score(collider.score)
			collider.die()


func handle_oob():
	if global_position.y < 0:
		global_position.y = 0
	if global_position.y > get_viewport_rect().size.y - 60:
		global_position.y = get_viewport_rect().size.y - 60
	if global_position.x < 0:
		global_position.x = 0
	if global_position.x > get_viewport_rect().size.x - 60:
		global_position.x = get_viewport_rect().size.x - 60


func move_to_cursor():
	var direction := get_global_mouse_position() - position
	var collision := move_and_collide(direction)

	handle_collision(collision)


func _on_attack_start():
	if input_disabled:
		return

	weapon.attack_start()


func _on_attack_stop():
	if input_disabled:
		return

	weapon.attack_stop()


func spawn():
	dead = false
	show()
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	enable_collisions()
	enable_input()
	weapon.set_process(true)
	weapon.temperature = 0


func despawn():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	disable_collisions()
	disable_input()
	weapon.set_process(false)
	weapon.temperature = 0


func enable_input():
	input_disabled = false


func disable_input():
	input_disabled = true


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


func _on_weapon_temperature_changed(temperature, max_temperature):
	emit_signal("weapon_temperature_changed", temperature, max_temperature)
