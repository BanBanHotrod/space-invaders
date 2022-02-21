extends Projectile


func _on_Projectile_body_entered(body):
	print("body", body)
	if body.is_in_group("enemy"):
		die()
		body.take_damage(damage)
