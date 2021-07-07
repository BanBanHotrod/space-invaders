class_name Weapon
extends Spatial


export var projectile = preload("res://Projectiles/SimpleProjectile/SimpleProjectile.tscn")
export (bool) var automatic = true
export (float) var fire_rate = 0.1


var fire_rate_timer = 0.0


var attack: bool = false


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	fire_rate_timer += delta

	if attack and fire_rate_timer >= fire_rate:
		var new_projectile = projectile.instance()
		Global.root.add_child(new_projectile)
		new_projectile.translation = global_transform.origin
		fire_rate_timer = 0.0


func attack() -> void:
	attack = true


func attack_stop() -> void:
	attack = false
