extends Area2D
class_name Projectile


export (Vector2) var direction = Vector2.UP
export (float) var speed = 100.0
export (float) var max_time = 3.0
export (float) var damage = 1.0

var time := 0.0


func _process(delta):
  time += delta

  if time >= max_time:
    queue_free()


func _physics_process(delta):
  var velocity = direction.normalized() * speed
  position += velocity * delta


func die():
  speed = 0.0
  hide()
  $CollisionShape2D.disabled = true
  set_process(false)
  queue_free()
