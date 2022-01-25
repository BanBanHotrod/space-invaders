extends KinematicBody2D
class_name Enemy


export (float) var speed = 1.0
export (AudioStreamSample) var sound_death
export (float) var attack_chance = 0.1

var velocity := Vector2.ZERO
var initial_rotation := rotation
var random_max := 1000
var random_threshold := 0

var vertical_speed = 0.2
var horizontal_speed = 2.0
var time_per_direction = 2.0

var health = 1.0


signal enemy_destroyed(enemy)


func _ready():
  var textures_node = Global.root.get_node("Textures")
  $Sprite.texture = textures_node.get_node("GuitarEnemy").get_texture()
  random_threshold = random_max * attack_chance

  # offset timers to avoid attack synchronization
  # time range in seconds (0.95, 1.05)
  var offset_wait_time = 100 / float((randi() % 400) + 1) + 0.95
  $Timer.wait_time = offset_wait_time
  $Timer.start()


func roll_attack():
  var random_number = randi() % random_max

  if random_number < random_threshold:
    attack()


func attack():
  $Weapon.attack()


func take_damage(damage):
  health -= damage
  
  if health <= 0:
    die()


func die():
  if $CollisionShape2D.disabled:
    return

  $AudioStreamPlayer.stream = sound_death
  $AudioStreamPlayer.play()

  hide()
  $CollisionShape2D.disabled = true

  yield($AudioStreamPlayer, 'finished')
  emit_signal('enemy_destroyed', self)
  queue_free()

  Global.add_score(10)


func move(move_velocity: Vector2):
  var collision = move_and_collide(move_velocity)

  if collision:
    var collider = collision.collider

    if collider.is_in_group('projectile'):
      take_damage(collider.damage)

    if collider.is_in_group('player'):
      die()
      collider.die()


func _on_Timer_timeout():
  # roll_attack()
  pass
