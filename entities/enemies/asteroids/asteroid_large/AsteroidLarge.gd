extends Asteroid

export(PackedScene) var debris


func _ready():
	velocity = Vector2(randi() % 200 - 100, randi() % 200)


func die(_killed_by_player = false):
	if dead:
		return

	dead = true

	for _i in range(3):
		var drift = randi() % 200 - 100
		var debris_instance = debris.instance()
		debris_instance.global_position = position

		# conservation of momentum
		debris_instance.velocity = Vector2(velocity.x + drift, velocity.y - drift)
		Global.root.spawn_instance(debris_instance)

	.die()
