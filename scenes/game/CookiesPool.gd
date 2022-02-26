extends Node2D

export(PackedScene) var cookie_scene

var max_cookies := 100
var alive_cookies := {}
var dead_cookies := []


func _ready():
	for _i in range(max_cookies):
		var cookie_instance = cookie_scene.instance()

		cookie_instance.connect("cookie_destroyed", self, "_on_cookie_destroyed")

		dead_cookies.append(cookie_instance)
		add_child(cookie_instance)
		cookie_instance.despawn()


func spawn_cookie(cookie_position):
	if dead_cookies.size() == 0:
		print("Warning: Cookie pool is too small")
		return

	var cookie_instance = dead_cookies.pop_front()
	var cookie_name = cookie_instance.get_name()

	alive_cookies[cookie_name] = cookie_instance
	cookie_instance.global_position = cookie_position
	cookie_instance.spawn()


func _on_cookie_destroyed(cookie):
	if not cookie:
		print("Error: cookie is null in destroyed event handler!")
		return

	var cookie_name = cookie.get_name()

	if not cookie_name in alive_cookies.keys():
		print("Error: cookie not in alive cookies")
		return

	var cookie_instance = alive_cookies[cookie_name]
	var erased = alive_cookies.erase(cookie_name)

	if not erased:
		print("Warning: Failed to erase cookie from alive pool")

	cookie_instance.despawn()
	dead_cookies.append(cookie_instance)
