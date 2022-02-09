extends Node2D
class_name Game


var current_player := 0

var players := []


signal root_initialized
signal input_attack_start
signal input_attack_stop


func _ready():
  assert($AudioStreamPlayer != null)
  assert($Players/PlayerBrandon != null)
  assert($Players/PlayerCarro != null)
  assert($Players/PlayerConrad != null)
  assert($Players/PlayerKyle != null)

  Global.root = self
  Global.emit_signal('root_initialized')

  players.append($Players/PlayerBrandon)
  players.append($Players/PlayerCarro)
  players.append($Players/PlayerConrad)
  players.append($Players/PlayerKyle)

  for player in players:
    player.despawn()

  $Players/PlayerBrandon.spawn()

  randomize()

  $AudioStreamPlayer.play()


func _process(_delta):
  if Input.is_action_pressed("ui_cancel"):
    var result_value = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

    if result_value != OK:
      get_tree().quit()


func respawn_player():
  if players[current_player].total_lives > 0:
    players[current_player].spawn()
  else:
    var next_player = get_next_player()

    if next_player != null:
      next_player.spawn()
    else:
      var return_value := get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")
  
      if return_value != OK:
        print("Error changing scene:", return_value)
        get_tree().quit()


func get_next_player():
  for player in players:
    if player.total_lives > 0:
      return player

  return null


func process_input():
  if not Global.controls:
    return

  if Input.is_action_pressed("action_attack"):
    print('attack_start')
    emit_signal("attack_start")

  if Input.is_action_just_released("action_attack"):
    print('attack_stop')
    emit_signal("attack_stop")

