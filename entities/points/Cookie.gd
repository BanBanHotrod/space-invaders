extends RigidBody2D

var score := 100
var velocity := Vector2.ZERO


func _ready():
	# velocity = Vector2((randi() % 80) - 40, randi() % 300 + 200)

	apply_impulse(Vector2.ZERO, velocity)


func die():
	Global.root.points_effect.play()
	queue_free()


func _on_Timer_timeout():
	queue_free()


func _on_Points_body_entered(body):
	if body.is_in_group("player"):
		Global.add_score(score)
		die()
