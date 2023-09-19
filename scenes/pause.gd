extends Control

func _input(event):
	if event.is_action_released("ui_accept"):
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_released("restart"):
		get_tree().reload_current_scene()

	if event.is_action_released("fullscreen"):
		toggle_fullscreen()

	if event.is_action_released("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = get_tree().paused

func unpause():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = get_tree().paused

func toggle_fullscreen():
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_exit_button_pressed():
	unpause()
	get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_retry_button_pressed():
	unpause()
	get_tree().reload_current_scene()
