extends VBoxContainer

# When the players hits F10, it'll bring up the debug info.
func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_F10):
		if !visible:
			show()
		else:
			hide()
