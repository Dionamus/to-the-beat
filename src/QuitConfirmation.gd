# A quit confirmation prompt.
extends CenterContainer

# Emitted when the "No" buttons is pressed.
signal did_not_quit


# Quit the game when YesButton is pressed.
func _on_YesButton_pressed() -> void:
	get_tree().quit()


# Emit the `"did_not_quit"` signal.
func _on_NoButton_pressed() -> void:
	emit_signal("did_not_quit")
