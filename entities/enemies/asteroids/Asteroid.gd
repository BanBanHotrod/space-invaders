extends KinematicBody2D
class_name Asteroid

signal asteroid_destroyed(new_asteroids)
signal asteroids_destroyed

export(int) var total_health = 100
export(int) var score = 100
export(PackedScene) var death_effect
export(PackedScene) var points

var velocity := Vector2.ZERO
var invincible := false
var entered_stage := false
var dead := false

onready var damage_cooldown_timer = $DamageCooldownTimer
onready var collision_shape_2d = $CollisionShape2D
onready var color_material = $AnimatedSprite.material
onready var animated_sprite = $AnimatedSprite
onready var health = total_health

signal enemy_destroyed(enemy, killed_by_player)


func _ready():
	assert(damage_cooldown_timer != null)
	assert(collision_shape_2d != null)
	assert(color_material != null)
	assert(animated_sprite != null)


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.collider
		if collider.is_in_group("player"):
			if collider.grace:
				return

			collider.die()
			die()

		velocity = velocity.bounce(collision.normal)


func take_damage(damage):
	if invincible:
		return

	health -= damage

	if health <= 0:
		die()

	modulate.g = 0.5
	modulate.b = 0.5

	#color_material.set_shader_param("brightness", 0.5)
	$DamageCooldownTimer.start()
	collision_shape_2d.set_deferred("disabled", true)


func die(killed_by_player = false):
	disable_collision()
	hide()
	emit_signal("enemy_destroyed", self, killed_by_player)

	if points != null:
		var random_range = 1 + randi() % (Global.wave_number + 1)

		for _i in range(random_range):
			var points_instance = points.instance()

			points_instance.global_position = global_position
			points_instance.velocity = velocity
			Global.root.spawn_instance(points_instance)

	if death_effect != null:
		var death_effect_instance = death_effect.instance()

		Global.root.spawn_instance(death_effect_instance)

	queue_free()

	Global.root.asteroid_effect.play()


func move(move_velocity):
	position += move_velocity


func collision_disabled():
	return collision_shape_2d.disabled


func enable_collision():
	collision_shape_2d.set_deferred("disabled", false)


func disable_collision():
	collision_shape_2d.set_deferred("disabled", true)


func get_height():
	var frame_texture = animated_sprite.frames.get_frame("default", 0)

	return frame_texture.get_height() * animated_sprite.scale.y


func all_asteroids_destroyed():
	return get_tree().get_nodes_in_group("asteroid").size() == 1


func _on_DamageCooldownTimer_timeout():
	modulate.g = 1.0
	modulate.b = 1.0
	#color_material.set_shader_param("brightness", 0.0)
	collision_shape_2d.set_deferred("disabled", false)


func _on_Enemy_area_entered(area):
	if area.is_in_group("projectile"):
		take_damage(area.damage)
		area.die()


func _on_Enemy_body_entered(body):
	if body.is_in_group("player"):
		if body.grace:
			return

		die()
		body.die()
