extends KinematicBody2D


const velocity := Vector2.DOWN
const speed := 200.0


func _physics_process(delta):
  var collision = move_and_collide(velocity.normalized() * speed * delta)
  
  if collision:
    var collider = collision.collider
    
    if collider.is_in_group('player'):
      queue_free()
