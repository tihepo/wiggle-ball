extends Node3D

func _on_start_button_pressed():
	start_game()

func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _unhandled_input(event):
	if event.is_action_released("ui_accept"):
		start_game()

	if event.is_action_released("fullscreen"):
		toggle_fullscreen()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func start_game():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
