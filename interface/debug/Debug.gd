extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# When the players hits F10, it'll bring up the debug info.
func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_key_pressed(KEY_F10):
				if !visible:
					show()
				elif visible:
					hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
