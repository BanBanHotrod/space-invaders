extends Node2D


var audio_player: AudioStreamPlayer


func _ready():
  $AudioStreamPlayer.play()


func _on_Start_pressed():
  $AudioStreamPlayer.stop()

  var return_value = get_tree().change_scene("res://scenes/game/Game.tscn")

  if return_value != OK:
    print("Error changing scene:", return_value)
    get_tree().quit()


func _on_Quit_pressed():
  $AudioStreamPlayer.stop()
  get_tree().quit()
