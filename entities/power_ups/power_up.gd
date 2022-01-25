extends KinematicBody2D


func _ready():
  pass # Replace with function body.


func _physics_process(_delta):
  self.translate(Vector2(0, -0.1))


func _on_power_up_area_entered(_area):
  print('power up area entered')
  queue_free()
