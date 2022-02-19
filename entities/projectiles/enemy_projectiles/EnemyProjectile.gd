extends Projectile


func _on_Projectile_body_entered(body):
  if body.grace != null and body.grace:
    return

  if body.is_in_group('player'):
    body.die()
    die()
