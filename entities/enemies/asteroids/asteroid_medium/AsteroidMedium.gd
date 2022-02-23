extends Asteroid

export(PackedScene) var debris


func _ready():
	velocity = Vector2(randi() % 200, randi() % 200)


func die(_killed_by_player = false):
	if dead:
		return

	dead = true

	for _i in range(6):
		var x_drift = randi() % 200 - 100
		var y_drift = randi() % 200 - 100
		var debris_instance = debris.instance()
		debris_instance.global_position = position
		debris_instance.velocity = Vector2(velocity.x + x_drift, velocity.y + y_drift)
		Global.root.spawn_instance(debris_instance)

	.die()
