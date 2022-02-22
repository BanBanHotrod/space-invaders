extends Node2D

onready var animated_sprite := $AnimatedSprite


func _ready():
	assert(animated_sprite != null)

	animated_sprite.play()


func _on_AnimatedSprite_animation_finished():
	queue_free()
