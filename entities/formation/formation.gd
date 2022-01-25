extends Node2D
class_name Formation


var width := 10
var height := 50
var enemy: PackedScene = null
var enemies = []
var gap = 50

export (float) var vertical_speed = 0.2
export (float) var horizontal_speed = 2.0
export (float) var time_per_direction = 2.0

var current_time = time_per_direction / 2

func _physics_process(delta: float):
  current_time += delta

  if current_time >= time_per_direction:
    current_time = 0.0
    horizontal_speed *= -1

  for enemy_instance in enemies:
    if not is_instance_valid(enemy_instance):
      var enemy_index = enemies.find(enemy_instance)

      enemies.remove(enemy_index)

      continue

    enemy_instance.move(Vector2(horizontal_speed, vertical_speed))


func create_formation():
  if enemy == null:
    print('Error: Formation enemy is null')
    return

  for y in height:
    for x in width:
      var enemy_instance = enemy.instance()
      var screen_size = get_viewport_rect().size
      var formation_x_offset = int(screen_size.x / 2) - int((gap * width) / 2)

      enemy_instance.position.x = gap * x + formation_x_offset
      enemy_instance.position.y = -gap * y

      enemies.append(enemy_instance)

      Global.root.add_child(enemy_instance)
