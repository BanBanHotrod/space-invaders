extends Spatial


var audio_player: AudioStreamPlayer


func _ready() -> void:
  Global.root = self
  $AudioStreamPlayer.play()

