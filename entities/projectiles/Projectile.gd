extends Area2D
class_name Projectile

export(float) var speed = 100.0
export(float) var max_time = 3.0
export(float) var damage = 100.0
export(bool) var position_globally = true
export(float) var accuracy_variance = 0.0

var time := 0.0


func _ready():
	assert($CollisionShape2D != null)

	if accuracy_variance:
		var deviation = (
			(randi() % int(accuracy_variance * 100 * 2) - int(accuracy_variance * 100))
			/ 666.0
		)
		rotate(deviation)


func _process(delta):
	time += delta

	if time >= max_time:
		queue_free()

	var up_rotation = rotation - deg2rad(90)
	var direction := Vector2(cos(up_rotation), sin(up_rotation))
	var velocity = direction.normalized() * speed
	position += velocity * delta


func die():
	speed = 0.0
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	set_process(false)
	queue_free()
