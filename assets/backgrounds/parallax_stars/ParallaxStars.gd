extends Particles2D


func _ready():
  var return_value = Global.connect('set_stars_visibility', self, '_on_set_stars_visibility')
  if return_value != OK:
    print('Error connecting to signal:', return_value)
    get_tree().quit()

  return_value = Global.connect('set_stars_speed', self, '_on_set_stars_speed')
  if return_value != OK:
    print('Error connecting to signal:', return_value)
    get_tree().quit()

  return_value = Global.connect('set_stars_density', self, '_on_set_stars_density')
  if return_value != OK:
    print('Error connecting to signal:', return_value)
    get_tree().quit()


func _on_set_stars_visibility(visibility):
  emitting = visibility


func _on_set_stars_speed(speed):
  if speed < 0:
    speed = 0
  if speed > 64:
    speed = 64

  speed_scale = speed


func _on_set_stars_density(density):
  if density < 0:
    density = 0

  amount = density
