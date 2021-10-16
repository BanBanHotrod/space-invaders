extends KinematicBody
class_name Player


export (float) var speed = 1.0
export (NodePath) var weapon
export (AudioStreamSample) var sound_death

var velocity := Vector3.ZERO


func _ready() -> void:
  # TODO: make this more dynamic if needed
  self.weapon = $Weapon

  assert(self.weapon != null)
  assert(self.sound_death != null)

  self.velocity = Vector3.ZERO


func _physics_process(_delta: float) -> void:
  self.handle_input(_delta)


func _input(event):
  if event is InputEventMouseMotion:
    # convert screen space to world coordinates

    var mouse_position = event.position
    var camera = get_node("/root/Root/ViewportContainer/Viewport/World/Camera")
    var world_position = camera.project_position(mouse_position, 0)

    self.transform.origin.x = world_position[0]
    self.transform.origin.y = world_position[1]


func _on_Area_area_entered(area):
  print("player area entered", area.collision_layer, area.name)
  match area.collision_layer:
    0b10:
      self.die()
    0b100000:
      self.die()
    0b10000:
      self.weapon.increment_tier()
    _:
      pass


func die() -> void:
  self.speed = 0.0

  $AudioStreamPlayer.stream = self.sound_death
  $AudioStreamPlayer.play()

  self.hide()
  $CollisionShape.disabled = true
  $Area/CollisionShape.disabled = true

  yield($AudioStreamPlayer, "finished")
  queue_free()

  var return_value = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

  if return_value != OK:
    print("Error changing scene:", return_value)
    get_tree().quit()


func handle_input(_delta: float) -> void:
  # disable keyboard movement
  # handle_input_movement(_delta)
  handle_input_attack()


func handle_input_movement(_delta: float) -> void:
  var input_direction_x: float = (
    Input.get_action_strength("move_right") -
    Input.get_action_strength("move_left")
  )

  var input_direction_y: float = (
    Input.get_action_strength("move_down") -
    Input.get_action_strength("move_up")
  )

  self.velocity.x = input_direction_x
  self.velocity.y = -input_direction_y
  self.velocity = move_and_slide(self.velocity.normalized() * self.speed * _delta)

  if is_equal_approx(input_direction_x, 0.0) and is_equal_approx(input_direction_y, 0.0):
    self.velocity = Vector3.ZERO


func handle_input_attack() -> void:
  if Input.is_action_pressed("action_attack"):
    self.weapon.attack_start()

  if Input.is_action_just_released("action_attack"):
    self.weapon.attack_stop()
