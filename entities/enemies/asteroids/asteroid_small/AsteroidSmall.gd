extends Asteroid


func _ready():
	velocity = Vector2(randi() % 400, randi() % 400)


func die(_killed_by_player = false):
	emit_signal("asteroid_destroyed", [])

	.die()

