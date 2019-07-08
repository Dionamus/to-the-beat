extends Button

func _on_QuitToMainMenuButton_pressed() -> void:
	get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")
