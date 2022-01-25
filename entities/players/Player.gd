extends KinematicBody2D
class_name Player


export (float) var speed = 0.0001
export (NodePath) var weapon
export (AudioStreamSample) var sound_death

var previous_position = null


func _ready() -> void:
  # TODO: make this more dynamic if needed
  weapon = $Weapon

  assert($Weapon != null)
  assert(sound_death != null)

  previous_position = position

  var return_value = Global.connect('root_initialized', self, 'on_root_initialized')
  print(return_value)


func on_root_initialized():
  print('h')


func _physics_process(delta: float) -> void:
  if Global.controls:
    handle_input(delta)
    move_to_cursor()
  else:
    $Weapon.attack_stop()


func die() -> void:
  speed = 0.0

  $AudioStreamPlayer.stream = sound_death
  $AudioStreamPlayer.play()

  hide()
  $CollisionShape2D.disabled = true

  yield($AudioStreamPlayer, "finished")
  queue_free()

  var return_value = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

  if return_value != OK:
    print("Error changing scene:", return_value)
    get_tree().quit()


func move_to_cursor():
  var direction = get_global_mouse_position() - position
  var collision = move_and_collide(direction)

  if collision:
    var collider = collision.collider

    if collider.is_in_group('enemy'):
      die()
      collider.die()
    if collider.is_in_group('projectile'):
      die()


func handle_input(_delta: float) -> void:
  handle_input_attack()


func handle_input_attack() -> void:
  if Input.is_action_pressed("action_attack"):
    $Weapon.attack_start()

  if Input.is_action_just_released("action_attack"):
    $Weapon.attack_stop()
