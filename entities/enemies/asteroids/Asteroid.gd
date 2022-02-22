extends KinematicBody2D
class_name Asteroid


signal asteroid_destroyed(new_asteroids)
signal asteroids_destroyed()


export(int) var total_health = 100
export(int) var score = 100
export(PackedScene) var death_effect

var pickup = null
var velocity := Vector2.ZERO
var invincible := false
var entered_stage := false

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

	if not entered_stage:
		if position.y > 0:
			entered_stage = true
	else:
		if position.x > get_viewport_rect().size.x or position.x < 0:
			die()
		if position.y > get_viewport_rect().size.y or position.y < 0:
			die()


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

	queue_free()

	emit_signal("enemy_destroyed", self, killed_by_player)

	if pickup != null:
		var pickup_instance = pickup.instance()

		pickup_instance.position = position
		Global.root.add_child(pickup_instance)

	if death_effect != null:
		var death_effect_instance = death_effect.instance()

		death_effect_instance.position = position
		Global.root.add_child(death_effect_instance)


func move(move_velocity):
	position += move_velocity
	if position.y < 0:
		disable_collision()
	elif collision_disabled():
		enable_collision()

	if position.y > 720 + 100:
		die(false)


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
