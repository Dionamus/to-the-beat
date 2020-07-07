extends Control

onready var player1 = $VBoxContainer/HBoxContainer/Player1
onready var player2 = $VBoxContainer/HBoxContainer/Player2
onready var devices = $VBoxContainer/HBoxContainer/Devices
onready var keyboard = $VBoxContainer/HBoxContainer/Devices/Keyboard
onready var controller1 = $VBoxContainer/HBoxContainer/Devices/Controller1
onready var controller2 = $VBoxContainer/HBoxContainer/Devices/Controller2

# This is used to prevent devices from swapping from one end column to another
# (i.e. swapping from player 1 to player 2), instead of swapping to adjacent
# columns (i.e. from player 1 to devices, or from player 2 to devices). This is
# functionality is facilitated with a timer
onready var input_allowed = true

func _input(event):
	if input_allowed:
		input_allowed = false
		# FIXME: Update the InputMap when devices are swapped.
		if event is InputEventKey:
			# Assign to keyboard to player 1 if under devices, or back to devices
			# if under player 2.
			if event.scancode == KEY_LEFT:
				if keyboard.get_parent().name == "Devices":
					move_device_to_column(keyboard, player1)
				elif keyboard.get_parent().name == "Player2":
					move_device_to_column(keyboard, devices)
			# Assign the keyboard to player 2.
			elif event.scancode == KEY_RIGHT:
				if keyboard.get_parent().name == "Devices":
					move_device_to_column(keyboard, player2)
				elif keyboard.get_parent().name == "Player1":
					move_device_to_column(keyboard, devices)
		elif event is InputEventJoypadButton:
			if event.device == 0:
				# Assign the first controller to player 1.
				if event.button_index == JOY_DPAD_LEFT:
					if keyboard.get_parent().name == "Devices":
						move_device_to_column(controller1, player1)
					elif keyboard.get_parent().name == "Player2":
						move_device_to_column(controller1, devices)
				# Assign the first controller to player 2.
				elif event.button_index == JOY_DPAD_RIGHT:
					if keyboard.get_parent().name == "Devices":
						move_device_to_column(controller1, player2)
					elif keyboard.get_parent().name == "Player1":
						move_device_to_column(controller1, devices)
			elif event.device == 1:
				# Assign the second controller to player 1.
				if event.button_index == JOY_DPAD_LEFT:
					if keyboard.get_parent().name == "Devices":
						move_device_to_column(controller2, player1)
					elif keyboard.get_parent().name == "Player2":
						move_device_to_column(controller2, devices)
				# Assign the second controller to player 2.
				elif event.button_index == JOY_DPAD_RIGHT:
					if keyboard.get_parent().name == "Devices":
						move_device_to_column(controller2, player2)
					elif keyboard.get_parent().name == "Player1":
						move_device_to_column(controller2, devices)
		$InputTimer.start()

func move_device_to_column(device: Node, column: Node):
	device.get_parent().remove_child(device)
	column.add_child(device)

func _on_InputTimer_timeout():
	input_allowed = true
