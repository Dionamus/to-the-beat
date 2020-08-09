extends CenterContainer

signal did_not_quit


# Quit the game when YesButton is pressed.
func _on_YesButton_pressed() -> void:
	get_tree().quit()


# When NoButton is pressed, emit a signal that the button has been pressed.
func _on_NoButton_pressed() -> void:
	emit_signal("did_not_quit")
