extends Weapon


func _process(delta):
  rotate(1.618033988749894 * 1.2 * delta)
