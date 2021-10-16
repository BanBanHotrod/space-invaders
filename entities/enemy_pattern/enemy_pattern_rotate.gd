extends Spatial


export (float) var speed = 1.0
export (float) var radius = 10.0

var elapsed_time := 0.0


func _process(_delta):
  self.move_circular(_delta)
  self.elapsed_time += _delta


func move_circular(_delta):
  self.rotate_z(PI * _delta)

  for child in self.get_children():
    if child.is_class('Spatial'):
      child.global_rotate(Vector3(0, 0, 1), PI * _delta * -1)
