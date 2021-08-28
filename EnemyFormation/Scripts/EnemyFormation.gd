extends KinematicBody


var velocity := Vector3.ZERO

export (float) var speed := 1.0


func _ready():
  self.velocity = Vector3(1.0, 0.0, 0.0)


func _physics_process(delta: float) -> void:
  var collision = self.move_and_collide(self.velocity.normalized() * speed * delta)

  if collision != null:
    var collision_layer = collision.collider.get_collision_layer()

    move_and_collide(Vector3(0.0, -1.0, 0.0).normalized() * speed * delta)

    if collision_layer == 0b1000:
      self.velocity *= -1.0

  self.speed += 0.001

  if len($Enemies.get_children()) == 0:
    print('all enemies dead')
