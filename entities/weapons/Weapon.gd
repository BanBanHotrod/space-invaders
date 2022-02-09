extends Node2D
class_name Weapon


export (PackedScene) var projectile

var projectile_speed := 500.0
var cooldown := 1.0
var cooldown_limit := 1.0
var attacking := false


func _ready():
  assert($AudioStreamPlayer != null)


func _process(delta):
  cooldown -= delta

  if attacking:
    attack()


func attack():
  if cooldown > 0.0:
    return

  $AudioStreamPlayer.play()

  var new_projectile = projectile.instance()

  Global.root.add_child(new_projectile)

  new_projectile.position = global_transform.origin
  print('projectile spawned')
  
  cooldown = cooldown_limit


func attack_start():
  attacking = true


func attack_stop():
  attacking = false
