extends Spatial


export (int) var total_stars := 1000
export (float) var speed := 1.0
export (PackedScene) var star

var stars := []


func _ready():
  for _star in range(self.total_stars):
    var star_instance: Spatial = self.star.instance()

    star_instance = randomize_star(star_instance)
    self.stars.append(star_instance)
    add_child(star_instance)


func random_x():
  var random_x = float((randi() % 640 - 320)) / 10

  return random_x


func random_y():
  var random_y = float((randi() % 640 - 320)) / 10

  return random_y


func random_position():
  return Vector3(self.random_x(), self.random_y(), -10)


func random_scale():
  var random_scale = randi() % 100 + 100
  random_scale = 50.0 / float(random_scale)

  return Vector3(random_scale, random_scale, random_scale)


func random_speed():
  var random_speed = randi() % 10 + 8
  random_speed = 1 / float(random_speed)

  return random_speed


func randomize_star(star_instance):
  star_instance.translation = self.random_position()
  star_instance.scale = self.random_scale()
  star_instance.speed = self.random_speed()

  return star_instance


func _process(_delta):
  for star_instance in self.stars:
    if star_instance.translation.y <= -32:
      star_instance.translation.y = 32
      star_instance.translation.x = self.random_x()
      star_instance.scale = self.random_scale()
      star_instance.speed = self.random_speed()
