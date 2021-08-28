extends State
class_name EnemyState


# Typed reference to the player node.
var enemy: Enemy


func _ready() -> void:
	yield(owner, "ready")
	enemy = owner as Enemy
	assert(enemy != null)
