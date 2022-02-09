extends KinematicBody2D
class_name Enemy


export (float) var speed = 1.0
export (AudioStreamSample) var sound_death
export (Array, PackedScene) var power_ups = []

onready var velocity := Vector2.ZERO
onready var attack_cooldown := 0
onready var health = 1.0


signal enemy_destroyed(enemy)


func _ready():
  assert($Timer != null)
  assert($CollisionShape2D != null)
  assert($AudioStreamPlayer != null)

  attack_cooldown = randi() % 100

  $Timer.wait_time = attack_cooldown
  $Timer.start()


func attack():
  $Weapon.attack()


func take_damage(damage):
  health -= damage
  
  if health <= 0:
    die()


func die():
  if $CollisionShape2D.disabled:
    return

  $AudioStreamPlayer.play()

  hide()
  $CollisionShape2D.disabled = true

  yield($AudioStreamPlayer, 'finished')
  emit_signal('enemy_destroyed', self)
  queue_free()

  Global.add_score(10)
  
  if true or randi() % 200 == 0:
    var random_powerup = randi() % power_ups.size()
    var power_up_instance = power_ups[random_powerup].instance()
    
    power_up_instance.position = position
    Global.root.add_child(power_up_instance)
  elif power_ups.size() == 1:
    var power_up_instance = power_ups[0].instance()
    
    power_up_instance.position = position
    Global.root.add_child(power_up_instance)


func move(move_velocity: Vector2):
  return
  var collision = move_and_collide(move_velocity)

  if collision:
    var collider = collision.collider

    if collider.is_in_group('projectile'):
      take_damage(collider.damage)
      collider.die()

    if collider.is_in_group('player'):
      die()
      collider.die()


func _on_Timer_timeout():
  if position.y > 0:
    attack()
