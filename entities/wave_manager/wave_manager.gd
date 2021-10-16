extends Node


export (Array, PackedScene) var waves = []

var current_wave := 0


func _ready():
  var wave_instance = self.waves[self.current_wave].instance()
  wave_instance.connect("wave_cleared", self, "_on_wave_cleared")

  add_child(wave_instance)


func _on_wave_cleared(wave):
  print('wave %s cleared' % (self.current_wave + 1))
  self.current_wave += 1
  wave.queue_free()

  if self.current_wave >= len(self.waves):
    # TODO: signal stage cleared
    print('stage %s cleared' % 1)

    var return_value = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")
  
    if return_value != OK:
      print("Error changing scene:", return_value)
      get_tree().quit()
  else:
    var next_wave = self.waves[self.current_wave]
    var next_wave_instance = next_wave.instance()
    next_wave_instance.connect("wave_cleared", self, "_on_wave_cleared")

    add_child(next_wave_instance)
