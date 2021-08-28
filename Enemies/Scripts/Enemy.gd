extends Area
class_name Enemy


export (float) var speed = 1.0
export (AudioStreamSample) var sound_death

var velocity := Vector3.ZERO


func _on_Enemy_area_entered(area):
  match area.collision_layer:
    0b1, 0b100:
      $AudioStreamPlayer.stream = self.sound_death
      $AudioStreamPlayer.play()

      self.hide()
      $CollisionShape.disabled = true

      yield($AudioStreamPlayer, "finished")
      queue_free()
    _:
      pass
