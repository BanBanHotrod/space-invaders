# Move.gd
extends PlayerState


func physics_update(delta: float) -> void:
	# TODO: define an input function in the Player.gd script to avoid
	# 		duplication
	var input_direction_x: float = (
		Input.get_action_strength("move_right") -
		Input.get_action_strength("move_left")
	)

	var input_direction_y: float = (
		Input.get_action_strength("move_down") -
		Input.get_action_strength("move_up")
	)

	player.velocity.x = input_direction_x
	player.velocity.y = -input_direction_y
	player.move_and_collide(player.velocity.normalized() * player.speed)
	
	if is_equal_approx(input_direction_x, 0.0) and is_equal_approx(input_direction_y, 0.0):
		state_machine.transition_to("Idle")

	# TODO: Find a way to make multiple states calculate on the same physics
	#		step to avoid jitter
	if Input.is_action_pressed("action_attack"):
		weapon.attack()
	if Input.is_action_just_released("action_attack"):
		weapon.attack_stop()
