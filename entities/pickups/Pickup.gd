extends Area2D

export(PackedScene) var pickup_effect

const direction := Vector2.DOWN
const speed := 100.0

var used := false

onready var audio_stream_player = $AudioStreamPlayer


func _ready():
	assert(audio_stream_player != null)


func _process(delta):
	var velocity = direction.normalized() * speed

	position += velocity * delta


func die():
	audio_stream_player.play()
	queue_free()


func _on_PickupBrandon_body_entered(body):
	if used:
		return

	used = true

	if body != Global.root.player_brandon:
		Global.root.set_current_player(Global.root.player_brandon)

	var pickup_effect_instance = pickup_effect.instance()

	Global.root.spawn_instance(pickup_effect_instance)
	Global.root.current_player.upgrade_weapon()
	Global.root.ui_brandon_skull.hide()
	queue_free()


func _on_PickupCarro_body_entered(body):
	if used:
		return

	used = true

	if body != Global.root.player_carro:
		Global.root.set_current_player(Global.root.player_carro)

	var pickup_effect_instance = pickup_effect.instance()

	Global.root.spawn_instance(pickup_effect_instance)

	Global.root.current_player.upgrade_weapon()
	Global.root.ui_carro_skull.hide()
	queue_free()


func _on_PickupConrad_body_entered(body):
	if used:
		return

	used = true

	if body != Global.root.player_conrad:
		Global.root.set_current_player(Global.root.player_conrad)

	var pickup_effect_instance = pickup_effect.instance()

	Global.root.spawn_instance(pickup_effect_instance)
	Global.root.current_player.upgrade_weapon()
	Global.root.ui_conrad_skull.hide()
	queue_free()


func _on_PickupKyle_body_entered(body):
	if used:
		return

	used = true

	if body != Global.root.player_kyle:
		Global.root.set_current_player(Global.root.player_kyle)

	var pickup_effect_instance = pickup_effect.instance()

	Global.root.spawn_instance(pickup_effect_instance)
	Global.root.current_player.upgrade_weapon()
	Global.root.ui_kyle_skull.hide()
	queue_free()
