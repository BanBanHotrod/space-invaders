extends Projectile

onready var timer = $Timer
onready var ray_cast_2d = $RayCast2D
onready var animated_sprite = $AnimatedSprite
onready var collision_shape_2d = $CollisionShape2D


func _ready():
	assert(timer != null)
	assert(ray_cast_2d != null)
	assert(animated_sprite != null)
	assert(collision_shape_2d != null)

	animated_sprite.hide()


func _physics_process(delta):
	if ray_cast_2d.is_colliding():
		var ray_cast_collider = ray_cast_2d.get_collider()

		if ray_cast_collider != null:
			animated_sprite.scale.x = (
				global_position.distance_to(ray_cast_2d.get_collision_point())
				/ 50
			)
			animated_sprite.global_position = lerp(
				global_position, ray_cast_2d.get_collision_point(), 0.5
			)

			ray_cast_collider.take_damage(damage)
			enable_cooldown()

	animated_sprite.show()


func _on_Projectile_body_entered(body):
	if collision_shape_2d.disabled:
		return

	body.take_damage(damage)
	enable_cooldown()


func _on_Timer_timeout():
	collision_shape_2d.disabled = false


func enable_cooldown():
	ray_cast_2d.enabled = false
	collision_shape_2d.set_deferred("disabled", true)
	timer.start()
