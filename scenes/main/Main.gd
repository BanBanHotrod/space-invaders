extends Spatial


var audio_player: AudioStreamPlayer


func _ready() -> void:
  Global.root = self
  $AudioStreamPlayer.play()


func _process(delta: float) -> void:
  if Input.is_action_pressed("ui_cancel"):
    var result_value = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

    if result_value != OK:
      get_tree().quit()
