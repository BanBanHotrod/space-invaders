extends Node2D
class_name Weapon


export (PackedScene) var projectile
export (bool) var automatic = true
export (float) var fire_rate = 0.1
export (AudioStreamSample) var sound_fire


var fire_rate_timer = 0.0
var attacking: bool = false


func _physics_process(delta: float) -> void:
  fire_rate_timer += delta

  if attacking and fire_rate_timer >= fire_rate:
    attack()


func attack() -> void:
  $AudioStreamPlayer.stream = sound_fire
  $AudioStreamPlayer.play()

  var new_projectile = projectile.instance()

  Global.root.add_child(new_projectile)

  new_projectile.position = global_transform.origin
  fire_rate_timer = 0.0


func attack_start() -> void:
  attacking = true


func attack_stop() -> void:
  attacking = false
