class_name Projectile
extends KinematicBody


export (float) var speed = 1.0
export (float) var max_time = 3.0


var velocity := Vector3(0.0, 1.0, 0.0)
var time := 0.0


func _ready() -> void:
	pass


func move(delta: float) -> void:
	var collision = move_and_collide(velocity.normalized() * speed * delta)


func _process(delta: float) -> void:
	# check lifetime
	time += delta

	if time >= max_time:
		self.queue_free()


func _physics_process(delta: float) -> void:
	move(delta)
