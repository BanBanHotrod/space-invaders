extends Node2D


func _ready():
  $AnimatedSprite.play()
  $AudioStreamPlayer.play()


func _on_AnimatedSprite_animation_finished():
  Global.root.respawn_player()
  queue_free()
