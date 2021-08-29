extends MarginContainer


var audio_player: AudioStreamPlayer


func _ready():
  $AudioStreamPlayer.play()


func _on_Button_pressed():
  $AudioStreamPlayer.stop()
  var return_value = get_tree().change_scene("res://scenes/main/Main.tscn")

  if return_value != OK:
    print("Error changing scene:", return_value)
    get_tree().quit()


func _on_Button2_pressed():
  $AudioStreamPlayer.stop()
  get_tree().quit()
