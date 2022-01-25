extends KinematicBody2D
class_name Projectile


export (float) var speed = 1.0
export (float) var max_time = 3.0
export (float) var damage = 1.0

var velocity := Vector2(0.0, -1.0)
var time := 0.0


func _process(delta: float) -> void:
  time += delta

  if time >= max_time:
    queue_free()


func _physics_process(delta: float) -> void:
  var collision = move_and_collide(velocity.normalized() * speed * delta)

  if collision:
    var collider = collision.collider

    if collider.is_in_group('enemy'):
      queue_free()
      collider.take_damage(damage)
