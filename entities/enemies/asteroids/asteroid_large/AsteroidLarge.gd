extends Asteroid


export(PackedScene) var debris


func _ready():
	velocity = Vector2(randi() % 200 - 100, randi() % 100 + 50)


func die(_killed_by_player = false):
	var new_asteroids = []

	for _i in range(3):
		var y_drift = randi() % 50
		var debris_instance = debris.instance()
		debris_instance.global_position = position
		debris_instance.velocity = Vector2(velocity.x, velocity.y + y_drift)
		new_asteroids.append(debris_instance)
		Global.root.add_child(debris_instance)

	emit_signal("asteroid_destroyed", new_asteroids)

	.die()
