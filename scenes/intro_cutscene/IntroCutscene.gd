extends Control


func _on_VideoPlayer_finished():
	var return_value = get_tree().change_scene("res://scenes/game/Game.tscn")
	if return_value != OK:
		print("Error changing scene:", return_value)
		get_tree().quit()
