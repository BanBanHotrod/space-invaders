extends RigidBody2D

var score := 100
var velocity := Vector2.ZERO
var spawned := true

onready var timer = $Timer

signal cookie_destroyed(cookie)


func _ready():
	assert(timer != null)


func _process(delta):
	global_position += velocity * delta


func die():
	emit_signal("cookie_destroyed", self)
	despawn()


func spawn():
	spawned = true
	set_process(true)
	show()
	timer.start()
	#velocity = Vector2((randi() % 80) - 40, randi() % 300 + 200)
	velocity = Vector2(0, 100)
	apply_impulse(Vector2.ZERO, velocity)


func despawn():
	spawned = false
	timer.stop()
	hide()
	set_process(false)


func _on_Timer_timeout():
	die()


func _on_Points_body_entered(body):
	if not spawned:
		return

	if body.is_in_group("player"):
		Global.add_score(score)
		Global.root.points_effect.play()
		die()
