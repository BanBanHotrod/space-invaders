extends Spatial


export (float) var speed := 1.0


func _process(_delta):
  self.translate(Vector3(0, -speed, 0))
