extends Area
class_name Projectile


export (float) var speed = 1.0
export (float) var max_time = 3.0


var velocity := Vector3(0.0, 1.0, 0.0)
var time := 0.0


func _ready() -> void:
  pass


func move(delta: float) -> void:
  self.translation += self.velocity.normalized() * speed * delta


func _process(delta: float) -> void:
  # check lifetime
  time += delta

  if time >= max_time:
    self.queue_free()


func _physics_process(delta: float) -> void:
  move(delta)


func _on_Area_area_entered(area):
  match area.collision_layer:
    0b10, 0b100000:
      queue_free()
    _:
      pass
