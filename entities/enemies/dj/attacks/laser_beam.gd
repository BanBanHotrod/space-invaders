extends Spatial


export (float) var rotation_speed = 1.0

var rotate_left := true


func _physics_process(delta):
  var rotation = deg2rad(rad2deg(rotation_degrees.z))

  print(rotation)

  if self.rotate_left and rotation > -90.0 and rotation < 0:
    self.rotation_speed = -self.rotation_speed
    self.rotate_left = false
  elif not self.rotate_left and rotation < 90.0 and rotation > 0:
    self.rotation_speed = -self.rotation_speed
    self.rotate_left = true

  rotate_z(deg2rad(rotation_speed) * delta)
