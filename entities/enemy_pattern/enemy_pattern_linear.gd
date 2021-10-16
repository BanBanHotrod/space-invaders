extends Spatial


export (float) var speed = 1.0
export (float) var length = 1.0

var elapsed_time := 0.0


func _process(delta):
  self.move_linear()
  self.elapsed_time += delta


func move_linear() -> void:
  self.transform.origin.x = cos(self.speed * self.elapsed_time) * self.length
