extends Node2D


export (float) var speed := 1.0


func _process(_delta):
  self.position += Vector2(0, -speed)
