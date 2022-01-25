extends Node2D


var audio_player: AudioStreamPlayer


func _ready() -> void:
  Global.root = self
  Global.emit_signal('root_initialized')

  # randomize the seed of the random number generator
  randomize()

  $AudioStreamPlayer.play()


func _process(_delta: float) -> void:
  if Input.is_action_pressed("ui_cancel"):
    var result_value = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

    if result_value != OK:
      get_tree().quit()
