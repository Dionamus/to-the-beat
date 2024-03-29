# A button that quits to the main menu.
extends Button


# Quits to the main menu.
func _on_QuitToMainMenuButton_pressed() -> void:
	# Reset bindings to default before going back to the main menu.
	for input in Settings.settings["input"].keys():
		ProjectSettings.set_setting("input/" + input, Settings.settings["input"][input])

	var error = get_tree().change_scene("res://src/MainMenu.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the main menu.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the main menu.")

	# This line below fixed a bug where the main menu's script didn't work. 
	get_tree().paused = false
