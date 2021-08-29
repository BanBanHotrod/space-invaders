extends State
class_name PlayerState


var player: Player

var weapon: Weapon


func _ready() -> void:
	yield(owner, "ready")
	player = owner as Player
	assert(player != null)

	var weapon_node = owner.get_node("Weapon")
	weapon = weapon_node as Weapon
	assert(weapon != null)
