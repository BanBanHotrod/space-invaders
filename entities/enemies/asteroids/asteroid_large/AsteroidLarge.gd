extends Asteroid

export(PackedScene) var debris


func _ready():
	velocity = Vector2(randi() % 200 - 100, randi() % 100 + 50)


func die(_killed_by_player = false):
	if dead:
		return

	dead = true

	for _i in range(3):
		var y_drift = randi() % 50
		var debris_instance = debris.instance()
		debris_instance.global_position = position
		debris_instance.velocity = Vector2(velocity.x, velocity.y + y_drift)
		Global.root.add_child(debris_instance)

	.die()
