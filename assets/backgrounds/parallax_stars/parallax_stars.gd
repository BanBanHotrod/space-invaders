extends Node2D


export (int) var total_stars := 1000
export (float) var speed := 1.0
export (PackedScene) var star

var stars := []

var width: int = int(OS.get_real_window_size().x)
var height: int = int(OS.get_real_window_size().y)


func _ready():
  for _star in range(self.total_stars):
    var star_instance: Node2D = self.star.instance()

    star_instance = randomize_star(star_instance)
    self.stars.append(star_instance)
    add_child(star_instance)


func random_x():
  var random_x = float((randi() % width - height))

  return random_x


func random_y():
  var random_y = float((randi() % width - height))

  return random_y


func random_position():
  return Vector2(self.random_x(), self.random_y())


func random_scale():
  var random_scale = randi() % 100 + 100
  random_scale = 50.0 / float(random_scale)

  return Vector2(random_scale, random_scale)


func random_speed():
  var random_speed = randi() % 100 + 60
  random_speed = float(random_speed) / 100

  return random_speed


func randomize_star(star_instance):
  star_instance.position = self.random_position()
  star_instance.scale = Vector2(1, 1) #self.random_scale()
  star_instance.speed = self.random_speed()

  return star_instance


func _process(_delta):
  for star_instance in self.stars:
    if star_instance.position.y < -32:
      star_instance.position.y = height + 32
      star_instance.position.x = self.random_x()
      star_instance.scale = Vector2(1, 1) #self.random_scale()
      star_instance.speed = self.random_speed()
