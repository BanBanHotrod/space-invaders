extends Area2D
class_name Enemy

export(int) var total_health = 100
export(int) var score = 100
export(bool) var auto_attack = true
export(int) var attack_cooldown := 0
export(bool) var random_attack_cooldown := false

var pickup = null
var velocity := Vector2.ZERO
var invincible := false

onready var weapon_cooldown_timer = $WeaponCooldownTimer
onready var damage_cooldown_timer = $DamageCooldownTimer
onready var collision_shape_2d = $CollisionShape2D
onready var weapon = $Weapon
onready var color_material = $AnimatedSprite.material
onready var animated_sprite = $AnimatedSprite
onready var health = total_health

signal enemy_destroyed(enemy, killed_by_player)


func _ready():
	assert(weapon_cooldown_timer != null)
	assert(damage_cooldown_timer != null)
	assert(collision_shape_2d != null)
	#assert(weapon != null)
	assert(color_material != null)
	assert(animated_sprite != null)

	if auto_attack:
		if random_attack_cooldown:
			reset_attack_cooldown()

		weapon_cooldown_timer.start()


func reset_attack_cooldown():
	var random_attack_cooldown = randi() % attack_cooldown + 1
	weapon_cooldown_timer.wait_time = attack_cooldown


func attack():
	weapon.attack()


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


func move(move_velocity: Vector2):
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


func _on_DamageCooldownTimer_timeout():
	modulate.g = 1.0
	modulate.b = 1.0
	#color_material.set_shader_param("brightness", 0.0)
	collision_shape_2d.set_deferred("disabled", false)


func _on_WeaponCooldownTimer_timeout():
	if position.y > 0:
		attack()

	if random_attack_cooldown:
		reset_attack_cooldown()

	weapon_cooldown_timer.start()


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
