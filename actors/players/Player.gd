extends KinematicBody
class_name Player


export (float) var speed := 1.0
export (NodePath) var weapon := NodePath()
export (AudioStreamSample) var sound_death

var velocity := Vector3.ZERO


func _on_Area_area_entered(area):
  print("player area entered", area.collision_layer, area.name)
  match area.collision_layer:
    0b10:
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
    _:
      pass
