extends Button

func _on_QuitToMainMenuButton_pressed() -> void:
	get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")
	
	# This line below fixed a bug where the main menu's script didn't work. 
	get_tree().paused = false
