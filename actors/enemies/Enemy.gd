extends Spatial
class_name Enemy


export (float) var speed = 1.0
export (AudioStreamSample) var sound_death
export (float) var attack_chance = 0.1

var velocity := Vector3.ZERO
var initial_rotation := self.rotation
var random_max := 1000
var random_threshold := 0


signal enemy_destroyed(enemy)


func _ready():
  self.random_threshold = self.random_max * self.attack_chance

  # offset timers to avoid attack synchronization
  # time range in seconds (0.95, 1.05)
  var offset_wait_time = 100 / float((randi() % 400) + 1) + 0.95
  $Timer.wait_time = offset_wait_time
  $Timer.start()


func roll_attack():
  var random_number = randi() % self.random_max

  if random_number < self.random_threshold:
    self.attack()


func attack():
  $Weapon.attack()


func _on_Enemy_area_entered(area):
  match area.collision_layer:
    0b1, 0b100:
      # prevents multiple projectiles collisions from counting as enemy death
      if $Area/CollisionShape.disabled:
        return

      $AudioStreamPlayer.stream = self.sound_death
      $AudioStreamPlayer.play()

      self.hide()
      $Area/CollisionShape.disabled = true

      yield($AudioStreamPlayer, "finished")
      emit_signal("enemy_destroyed", self)
      queue_free()
    _:
      pass


func _on_Timer_timeout():
  self.roll_attack()
