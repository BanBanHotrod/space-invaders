extends KinematicBody2D
class_name Player


export (int) var total_lives = 1
export (PackedScene) var death_effect

onready var previous_position = null


func _ready():
  assert($Weapon != null)
  assert($AudioStreamPlayer != null)
  assert($CollisionShape2DCockpit != null)
  assert($CollisionShape2DWings != null)
  assert(death_effect != null)

  previous_position = position

  var return_value := Global.connect('root_initialized', self, '_on_root_initialized')
  if return_value != OK:
    print("Error connecting to signal:", return_value)
    get_tree().quit()


func _on_root_initialized():
  Global.root.connect('attack_start', self, '_on_attack_start')
  Global.root.connect('attack_stop', self, '_on_attack_stop')


func _physics_process(_delta):
  if Global.controls:
    move_to_cursor()


func die():
  total_lives -= 1

  var death_effect_instance = death_effect.instance()
  
  Global.root.add_child(death_effect_instance)
  death_effect_instance.position = position
  
  $CollisionShape2DCockpit.set_deferred("disabled", true)
  $CollisionShape2DWings.set_deferred("disabled", true)
  
  despawn()


func move_to_cursor():
  var direction := get_global_mouse_position() - position
  var collision := move_and_collide(direction)

  if collision:
    var collider := collision.collider
    print('collision from player')

    if collider.is_in_group('enemy'):
      die()
      collider.die()

    if collider.is_in_group('projectile'):
      die()
      collider.die()


func teleport_to_cursor():
  position = get_global_mouse_position()


func _on_attack_start():
  $Weapon.attack_start()


func _on_attack_stop():
  $Weapon.attack_stop()


func spawn():
  show()
  $CollisionShape2DCockpit.disabled = false
  $CollisionShape2DWings.disabled = false
  set_process(true)


func despawn():
  hide()
  $CollisionShape2DCockpit.disabled = true
  $CollisionShape2DWings.disabled = true
  set_process(false)
