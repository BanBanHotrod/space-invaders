extends Node2D
class_name Formation


signal formation_cleared


export (Array, PackedScene) var pickups = []

var vertical_speed := 20.0
var horizontal_speed := 40.0
var time_per_direction := 2.0
var current_direction_time = time_per_direction / 2
var width := 10
var height := 50
var enemy: PackedScene = null
var enemies := []
var total_enemies := 0
var horizontal_gap := 50
var vertical_gap := 80
var score_multiplier := 1
var velocity := Vector2.ZERO


func _process(delta):
  current_direction_time += delta

  if current_direction_time >= time_per_direction:
    current_direction_time = 0.0
    horizontal_speed *= -1

  for enemy_instance in enemies:
    enemy_instance.position += velocity * delta


func create_formation(wave_number=0):
  if enemy == null:
    print('Error: Formation enemy is null')
    return
    
  var pickup_x = 0
  var pickup_y = 0

  if width > 1:
    pickup_x = randi() % (width - 1)
  
  if height > 1:
    pickup_y = randi() % (height - 1)

  velocity = Vector2(vertical_speed + (10 * wave_number), horizontal_speed + (20 * wave_number))

  for y in height:
    for x in width:
      var enemy_instance = enemy.instance()
      var screen_size = get_viewport_rect().size
      var formation_x_offset = int(screen_size.x / 2) - int((horizontal_gap * width) / 2.0)
      
      if true or y == pickup_y and x == pickup_x:
        #var random_pickup = randi() % (pickups.size() - 1)
        enemy_instance.pickup = pickups[0]

      enemy_instance.position.x = horizontal_gap * x + formation_x_offset
      enemy_instance.position.y = -vertical_gap * y
      enemy_instance.health = enemy_instance.total_health * (wave_number + 1)

      enemies.append(enemy_instance)

      enemy_instance.connect('enemy_destroyed', self, '_on_enemy_destroyed')

      Global.root.add_child(enemy_instance)

  total_enemies = enemies.size()
  score_multiplier = 1 + wave_number


func _on_enemy_destroyed(destroyed_enemy, killed_by_player):
  if killed_by_player:
    Global.add_score(destroyed_enemy.score * score_multiplier)

  for existing_enemy in enemies:
    if existing_enemy == destroyed_enemy:
      var enemy_index = enemies.find(existing_enemy)

      enemies.remove(enemy_index)

      total_enemies -= 1

      if total_enemies <= 0:
        emit_signal('formation_cleared')
