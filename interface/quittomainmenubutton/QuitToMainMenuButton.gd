extends Button

func _on_QuitToMainMenuButton_pressed():
	var error = get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the main menu.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")
	
	# This line below fixed a bug where the main menu's script didn't work. 
	get_tree().paused = false
