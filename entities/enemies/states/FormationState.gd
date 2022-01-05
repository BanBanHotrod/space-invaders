# EnemyState.gd
extends EnemyState


func enter(_msg := {}) -> void:
	enemy.velocity = Vector3(1.0, 0.0, 0.0)


func physics_update(delta: float) -> void:
	pass
