extends Asteroid


func _ready():
	velocity = Vector2(randi() % 400, randi() % 400)


func die(_killed_by_player = false):
	if dead:
		return

	dead = true

	if all_asteroids_destroyed():
		Global.emit_signal("asteroids_destroyed")

	.die()
