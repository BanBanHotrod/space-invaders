extends Area2D

const direction := Vector2.DOWN
const speed := 100.0


func _process(delta):
	var velocity = direction.normalized() * speed

	position += velocity * delta


func _on_PickupBrandon_body_entered(body):
	if body != Global.root.player_brandon:
		Global.root.set_current_player(Global.root.player_brandon)

	Global.root.current_player.upgrade_weapon()
	queue_free()


func _on_PickupCarro_body_entered(body):
	if body != Global.root.player_carro:
		Global.root.set_current_player(Global.root.player_carro)

	Global.root.current_player.upgrade_weapon()
	queue_free()


func _on_PickupConrad_body_entered(body):
	if body != Global.root.player_conrad:
		Global.root.set_current_player(Global.root.player_conrad)

	Global.root.current_player.upgrade_weapon()
	queue_free()


func _on_PickupKyle_body_entered(body):
	if body != Global.root.player_kyle:
		Global.root.set_current_player(Global.root.player_kyle)

	Global.root.current_player.upgrade_weapon()
	queue_free()


func _on_PickupUniversal_body_entered(body):
	body.upgrade_weapon()
	queue_free()
