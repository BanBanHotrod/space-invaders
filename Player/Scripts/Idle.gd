# Idle.gd
extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO


func update(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		state_machine.transition_to("Move")
	if Input.is_action_pressed("move_right"):
		state_machine.transition_to("Move")
	if Input.is_action_pressed("move_up"):
		state_machine.transition_to("Move")
	if Input.is_action_pressed("move_down"):
		state_machine.transition_to("Move")
	if Input.is_action_pressed("action_attack"):
		state_machine.transition_to("Attack")
