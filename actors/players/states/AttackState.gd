# Attack.gd
extends PlayerState


func physics_update(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		state_machine.transition_to("Move")
	if Input.is_action_pressed("move_right"):
		state_machine.transition_to("Move")
	if Input.is_action_pressed("move_up"):
		state_machine.transition_to("Move")
	if Input.is_action_pressed("move_down"):
		state_machine.transition_to("Move")

	state_machine.transition_to("Move")
