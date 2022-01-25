extends Node


enum EventType {
  SET_STARS_VISIBILITY,
  SET_STARS_SPEED,
  SET_STARS_DENSITY,
  SET_CONTROLS_ENABLED,
  CREATE_ASTEROID,
  CREATE_ENEMY,
  CREATE_FORMATION_BLOCK,
  ENTER_SHOP,
  SLEEP,
}

class ScriptEvent:
  var type = null
  var command = null
  var parameters = {}

onready var the_script_source = 'res://entities/the_narrator/the_script.cfg'
var the_script = []
var sleeping: bool = false
var line_number = 0

export (Array, PackedScene) var enemies = []
export (Array, PackedScene) var formations = []


func _ready():
  var return_value = Global.connect('root_initialized', self, '_on_root_initialized')
  if return_value != OK:
    print("Error connecting to signal:", return_value)
    get_tree().quit()


func _on_root_initialized():
  load_the_script()
  narrate()
  Global.disconnect('root_initialized', self, '_on_root_initialized')


func load_the_script():
  load_file(the_script_source)


func load_file(file_path):
  var file = File.new()

  file.open(file_path, File.READ)

  while not file.eof_reached():
    var line: String = file.get_line()

    line = line.strip_edges()

    if line.ends_with(';'):
      line = line.substr(0, len(line) - 1)

    if line.begins_with('#'):
      continue

    var tokens = line.split(' ')

    if not tokens[0]:
      continue

    var script_event = create_script_event(tokens)

    the_script.append(script_event)


func create_script_event(tokens):
  var script_event = ScriptEvent.new()

  var type = null
  var command = tokens[0]
  var parameters = {}

  # TODO: argument validation

  if command == 'stars':
    type = EventType.SET_STARS_VISIBILITY

    if tokens[1] == 'true':
      parameters.visible = true
    else:
      parameters.visible = false
  

    parameters.visible = tokens[1] == 'true'
  elif command == 'stars_speed':
    type = EventType.SET_STARS_SPEED
    parameters.speed = int(tokens[1])
  elif command == 'stars_density':
    type = EventType.SET_STARS_DENSITY
    parameters.density = int(tokens[1])
  elif command == 'controls':
    type = EventType.SET_CONTROLS_ENABLED
    parameters.enabled = int(tokens[1])
  elif command == 'create_asteroid':
    type = EventType.CREATE_ASTEROID
    parameters.count = int(tokens[1])
  elif command == 'create_enemy':
    type = EventType.CREATE_ENEMY
    parameters.enemy = int(tokens[1])
  elif command == 'create_formation_block':
    type = EventType.CREATE_FORMATION_BLOCK
    parameters.formation = int(tokens[1])
    parameters.enemy = int(tokens[2])
    parameters.width = int(tokens[3])
    parameters.height = int(tokens[4])
  elif command == 'sleep':
    type = EventType.SLEEP
    parameters.time = int(tokens[1])

  script_event.type = type
  script_event.command = command
  script_event.parameters = parameters

  return script_event


func narrate():
  if line_number >= the_script.size():
    return

  for i in range(line_number, the_script.size()):
    var script_event = the_script[i]

    if script_event.type == EventType.SET_STARS_VISIBILITY:
      var visible = script_event.parameters.visible

      Global.set_stars_visibility(visible)
    elif script_event.type == EventType.SET_STARS_SPEED:
      var speed = script_event.parameters.speed

      Global.set_stars_speed(speed)
    elif script_event.type == EventType.SET_STARS_DENSITY:
      var density = script_event.parameters.density

      Global.set_stars_density(density)
    elif script_event.type == EventType.SET_CONTROLS_ENABLED:
      var enabled = script_event.parameters.enabled

      Global.set_controls_enabled(enabled)
    elif script_event.type == EventType.CREATE_ASTEROID:
      var count = script_event.parameters.count

      Global.create_asteroid(count)
    elif script_event.type == EventType.CREATE_ENEMY:
      var enemy = script_event.parameters.enemy

      if enemies.size() <= enemy:
        return

      var enemy_instance = enemies[enemy].instance()

      enemy_instance.position.x = 100
      enemy_instance.position.y = 100

      Global.root.add_child(enemy_instance)
    elif script_event.type == EventType.CREATE_FORMATION_BLOCK:
      var formation = script_event.parameters.formation
      var enemy = script_event.parameters.enemy

      if formations.size() <= formation:
        print('Error: Formation size %s out of bounds' % formations.size())
        return

      if enemies.size() <= enemy:
        print('Error: Enemies size %s out of bounds' % enemies.size())
        return

      var formation_instance = formations[formation].instance()
      formation_instance.position.x = 640
      formation_instance.position.y = 0

      var width = script_event.parameters.width
      var height = script_event.parameters.height

      formation_instance.width = width
      formation_instance.height = height
      formation_instance.enemy = enemies[enemy]

      Global.root.add_child(formation_instance)
      formation_instance.create_formation()
    elif script_event.type == EventType.SLEEP:
      var time = script_event.parameters.time

      sleeping = true

      $Timer.wait_time = time

      if not $Timer.is_connected('timeout', self, '_on_sleep_complete'):
        var return_value = $Timer.connect('timeout', self, '_on_sleep_complete')

        if return_value != OK:
          print("Error connecting to signal:", return_value)
          get_tree().quit()

      $Timer.start()

      line_number += 1
      break

    line_number += 1


func _on_sleep_complete():
  sleeping = false
  narrate()

