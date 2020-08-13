# A menu that gives Skullgirls-like controller swapping.
extends Control

# The inputs in snake case.
const inputs_snake = [
	"up", "down", "left", "right", "light_punch", "heavy_punch", "light_kick", "heavy_kick", "block"
]

# Shortening NodePaths to variables.

onready var _player1 := $VBoxContainer/Players/Player1
onready var _player2 := $VBoxContainer/Players/Player2
onready var _devices := $VBoxContainer/Players/Devices
onready var _keyboard := $VBoxContainer/Players/Devices/Keyboard
onready var _controller1 := $VBoxContainer/Players/Devices/Controller1
onready var _controller2 := $VBoxContainer/Players/Devices/Controller2
onready var _ready_button := $VBoxContainer/ReadyButton

# This is used to prevent devices from swapping from one end column to another
# (i.e. swapping from player 1 to player 2), instead of swapping to adjacent
# columns (i.e. from player 1 to devices, or from player 2 to devices). This
# functionality is facilitated with a timer.
onready var _input_allowed := true


func _ready() -> void:
	_ready_button.visible = false


func _input(event: InputEvent) -> void:
	if visible:
		if _input_allowed:
			_input_allowed = false

			if event is InputEventKey:
				# Assign to keyboard to player 1 if under devices, or back to
				# devices if under player 2.
				if event.scancode == KEY_LEFT:
					if _keyboard.get_parent().name == "Devices":
						if _player1.get_child_count() == 1:
							move_device_to_column(_keyboard, _player1)
							assign_keyboard_to_player("p1_")
					elif _keyboard.get_parent().name == "Player2":
						move_device_to_column(_keyboard, _devices)
				# Assign the keyboard to player 2 if under devices, or back to
				# devices if under player 1.
				elif event.scancode == KEY_RIGHT:
					if _keyboard.get_parent().name == "Devices":
						if _player2.get_child_count() == 1:
							move_device_to_column(_keyboard, _player2)
							assign_keyboard_to_player("p2_")
					elif _keyboard.get_parent().name == "Player1":
						move_device_to_column(_keyboard, _devices)

				# Go back to the previous menu.
				elif event.scancode == KEY_ESCAPE:
					# Reset bindings to default before going back to the
					# main menu.
					for input in Settings.settings["input"].keys():
						ProjectSettings.set_setting(
							"input/" + input, Settings.settings["input"][input]
						)

					var error = get_tree().change_scene("res://src/MainMenu.tscn")
					match error:
						ERR_CANT_OPEN:
							printerr("Cannot open the scene to the main menu.")
						ERR_CANT_CREATE:
							printerr("Cannot instantiate the main menu.")
				# Enter the main stage. (FIXME: Enter the character selection
				# menu once it has been implemented.)
				elif _ready_button.visible and event.scancode == KEY_ENTER:
					var error = get_tree().change_scene("res://src/Stage.tscn")
					match error:
						ERR_CANT_OPEN:
							printerr("Cannot open the scene to the stage.")
						ERR_CANT_CREATE:
							printerr("Cannot instantiate the stage.")

			elif event is InputEventJoypadButton:
				if event.device == 0:
					# Assign the first controller to player 1 if under devices,
					# or back to devices if under player 2.
					if event.button_index == JOY_DPAD_LEFT:
						if _controller1.get_parent().name == "Devices":
							if _player1.get_child_count() == 1:
								move_device_to_column(_controller1, _player1)
								change_device_number("p1_", event.device)
						elif _controller1.get_parent().name == "Player2":
							move_device_to_column(_controller1, _devices)
					# Assign the first controller to player 2 if under devices, or
					# back to devices if under player 1.
					elif event.button_index == JOY_DPAD_RIGHT:
						if _controller1.get_parent().name == "Devices":
							if _player2.get_child_count() == 1:
								move_device_to_column(_controller1, _player2)
								change_device_number("p2_", event.device)
						elif _controller1.get_parent().name == "Player1":
							move_device_to_column(_controller1, _devices)

					# Go back to the previous menu.
					elif event.button_index == JOY_XBOX_B:
						# Reset bindings to default before going back to the
						# main menu.
						for input in Settings.settings["input"].keys():
							ProjectSettings.set_setting(
								"input/" + input, Settings.settings["input"][input]
							)

						var error = get_tree().change_scene("res://src/MainMenu.tscn")
						match error:
							ERR_CANT_OPEN:
								printerr("Cannot open the scene to the main menu.")
							ERR_CANT_CREATE:
								printerr("Cannot instantiate the main menu.")
					# Enter the main stage. (FIXME: Enter the character selection
					# menu once it has been implemented.)
					elif _ready_button.visible and event.button_index == JOY_START:
						var error = get_tree().change_scene("res://src/Stage.tscn")
						match error:
							ERR_CANT_OPEN:
								printerr("Cannot open the scene to the stage.")
							ERR_CANT_CREATE:
								printerr("Cannot instantiate the stage.")

				elif event.device == 1:
					# Assign the second controller to player 1 if under devices,
					# or back to devices if under player 2.
					if event.button_index == JOY_DPAD_LEFT:
						if _controller2.get_parent().name == "Devices":
							if _player1.get_child_count() == 1:
								move_device_to_column(_controller2, _player1)
								change_device_number("p1_", event.device)
						elif _controller2.get_parent().name == "Player2":
							move_device_to_column(_controller2, _devices)
					# Assign the second controller to player 2 if under devices, or
					# back to devices if under player 1.
					elif event.button_index == JOY_DPAD_RIGHT:
						if _controller2.get_parent().name == "Devices":
							if _player2.get_child_count() == 1:
								move_device_to_column(_controller2, _player2)
								change_device_number("p2_", event.device)
						elif _controller2.get_parent().name == "Player1":
							move_device_to_column(_controller2, _devices)

					elif (
						(
							Settings.settings["other"]["control_mode"]
							== Settings.TWO_PLAYER_SIMULTANEOUS
						)
						or (
							Settings.settings["other"]["control_mode"]
							== Settings.TWO_PLAYER_INDIVIDUAL
						)
					):
						# Go back to the previous menu.
						if event.button_index == JOY_XBOX_B:
							# Reset bindings to default before going back to the
							# main menu.
							for input in Settings.settings["input"].keys():
								ProjectSettings.set_setting(
									"input/" + input, Settings.settings["input"][input]
								)

							var error = get_tree().change_scene("res://src/MainMenu.tscn")
							match error:
								ERR_CANT_OPEN:
									printerr("Cannot open the scene to the main menu.")
								ERR_CANT_CREATE:
									printerr("Cannot instantiate the stage.")
						# Enter the main stage. (FIXME: Enter the character selection
						# menu once it has been implemented.)
						elif _ready_button.visible and event.button_index == JOY_START:
							var error = get_tree().change_scene("res://src/Stage.tscn")
							match error:
								ERR_CANT_OPEN:
									printerr("Cannot open the scene to the main menu.")
								ERR_CANT_CREATE:
									printerr("Cannot instantiate the stage.")

			if _player1.get_child_count() == 2 and _player2.get_child_count() == 2:
				_ready_button.visible = true
				_ready_button.grab_focus()
			else:
				_ready_button.visible = false
				_ready_button.release_focus()
			$InputTimer.start()


# Reparents `device` to `column`.
func move_device_to_column(device: Node, column: Node) -> void:
	device.get_parent().remove_child(device)
	column.add_child(device)


# Changes the `device` number the designated player (denoted by
# `player_prefix`). The `player_prefix` may be `"p1_"` for player 1, or `"p2_"'
# for player 2.
func change_device_number(player_prefix: String, device: int) -> void:
	for input in inputs_snake:
		for j in InputMap.get_action_list(player_prefix + input):
			if j is InputEventJoypadButton or j is InputEventJoypadMotion:
				var input_to_change = j
				InputMap.action_erase_event(player_prefix + input, input_to_change)
				input_to_change.device = device
				InputMap.action_add_event(player_prefix + input, input_to_change)


# Assigns the keyboard to the designated player (denoted by `player_prefix`).
# The `player_prefix` may be `"p1_"` for player 1, or `"p2_"' for player 2.
func assign_keyboard_to_player(player_prefix: String) -> void:
	if player_prefix == "p1_":
		# Unassign the keyboard from player 2 if it is assigned to them.
		for input in inputs_snake:
			if InputMap.action_has_event("p2_" + input, InputMap.get_action_list("kb_" + input)[0]):
				InputMap.action_erase_event(
					"p2_" + input, InputMap.get_action_list("kb_" + input)[0]
				)

		# And assign it to player 1 if it isn't assigned to them.
		for input in inputs_snake:
			if ! InputMap.action_has_event(
				"p1_" + input, InputMap.get_action_list("kb_" + input)[0]
			):
				InputMap.action_add_event("p1_" + input, InputMap.get_action_list("kb_" + input)[0])

	elif player_prefix == "p2_":
		# Unassign the keyboard from player 1 if it is assigned to them.
		for input in inputs_snake:
			if InputMap.action_has_event("p1_" + input, InputMap.get_action_list("kb_" + input)[0]):
				InputMap.action_erase_event(
					"p1_" + input, InputMap.get_action_list("kb_" + input)[0]
				)

		# And assign it to player 2 if it isn't assigned to them.
		for input in inputs_snake:
			if ! InputMap.action_has_event(
				"p2_" + input, InputMap.get_action_list("kb_" + input)[0]
			):
				InputMap.action_add_event("p2_" + input, InputMap.get_action_list("kb_" + input)[0])


# Allows input on timeout.
func _on_InputTimer_timeout() -> void:
	_input_allowed = true


# Starts the game.
func _on_ReadyButton_pressed() -> void:
	var error = get_tree().change_scene("res://src/Stage.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the stage.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")


# Goes back to the prevoius menu.
func _on_BackButton_pressed() -> void:
	var error = get_tree().change_scene("res://src/MainMenu.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the main menu.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")
