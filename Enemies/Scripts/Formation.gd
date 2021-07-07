# EnemyState.gd
extends EnemyState


func enter(_msg := {}) -> void:
	enemy.velocity = Vector2(1.0, 0.0)


func physics_update(delta: float) -> void:
	var collision = enemy.move_and_collide(enemy.velocity.normalized() * enemy.speed)
	if collision:
		enemy.velocity = Vector2(enemy.velocity.x * -1.0, 1.0)
		enemy.move_and_collide(enemy.velocity.normalized() * enemy.speed)
		enemy.velocity = Vector2(enemy.velocity.x, 0.0)
