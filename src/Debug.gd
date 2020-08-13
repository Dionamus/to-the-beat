# A monitor that displays the game's framerate, animation framerate, and tempo.
extends VBoxContainer


# Displays debug info when F10 is pressed.
func _unhandled_input(_event) -> void:
	if Input.is_key_pressed(KEY_F10):
		if ! visible:
			show()
		else:
			hide()
