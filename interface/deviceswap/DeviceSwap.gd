extends Control

onready var player1 = $VBoxContainer/Players/Player1
onready var player2 = $VBoxContainer/Players/Player2
onready var devices = $VBoxContainer/Players/Devices
onready var keyboard = $VBoxContainer/Players/Devices/Keyboard
onready var controller1 = $VBoxContainer/Players/Devices/Controller1
onready var controller2 = $VBoxContainer/Players/Devices/Controller2
onready var ready_button = $VBoxContainer/ReadyButton
# The inputs in snake case
const inputs_snake = ["up", "down", "left", "right", "light_punch",
"heavy_punch", "light_kick", "heavy_kick", "block"]

# This is used to prevent devices from swapping from one end column to another
# (i.e. swapping from player 1 to player 2), instead of swapping to adjacent
# columns (i.e. from player 1 to devices, or from player 2 to devices). This is
# functionality is facilitated with a timer
onready var input_allowed = true

func _ready():
	ready_button.visible = false

func _input(event):
	if visible:
		if input_allowed:
			input_allowed = false
			
			if event is InputEventKey:
				# Assign to keyboard to player 1 if under devices, or back to
				# devices if under player 2.
				if event.scancode == KEY_LEFT:
					if keyboard.get_parent().name == "Devices":
						if player1.get_child_count() == 1:
							move_device_to_column(keyboard, player1)
							assign_keyboard_to_player("p1_")
					elif keyboard.get_parent().name == "Player2":
						move_device_to_column(keyboard, devices)
				# Assign the keyboard to player 2 if under devices, or back to
				# devices if under player 1.
				elif event.scancode == KEY_RIGHT:
					if keyboard.get_parent().name == "Devices":
						if player2.get_child_count() == 1:
							move_device_to_column(keyboard, player2)
							assign_keyboard_to_player("p2_")
					elif keyboard.get_parent().name == "Player1":
						move_device_to_column(keyboard, devices)
				
				# Go back to the previous menu.
				elif event.scancode == KEY_ESCAPE:
					# Reset bindings to default before going back to the
					# main menu.
					for input in Settings.settings["input"].keys():
						ProjectSettings.set_setting("input/" + input,
							Settings.settings["input"][input])
					
					var error = get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")
					match error:
						ERR_CANT_OPEN:
							printerr("Cannot open the scene to the main menu.")
						ERR_CANT_CREATE:
							printerr("Cannot instantiate the main menu.")
				# Enter the main stage. (FIXME: Enter the character selection
				# menu once it has been implemented.)
				elif ready_button.visible and event.scancode == KEY_ENTER:
					var error = get_tree().change_scene("res://stages/base/Stage.tscn")
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
						if controller1.get_parent().name == "Devices":
							if player1.get_child_count() == 1:
								move_device_to_column(controller1, player1)
								change_device_number("p1_", event.device)
						elif controller1.get_parent().name == "Player2":
							move_device_to_column(controller1, devices)
					# Assign the first controller to player 2 if under devices, or
					# back to devices if under player 1.
					elif event.button_index == JOY_DPAD_RIGHT:
						if controller1.get_parent().name == "Devices":
							if player2.get_child_count() == 1:
								move_device_to_column(controller1, player2)
								change_device_number("p2_", event.device)
						elif controller1.get_parent().name == "Player1":
							move_device_to_column(controller1, devices)
					
					# Go back to the previous menu.
					elif event.button_index == JOY_XBOX_B:
						# Reset bindings to default before going back to the
						# main menu.
						for input in Settings.settings["input"].keys():
							ProjectSettings.set_setting("input/" + input,
								Settings.settings["input"][input])
						
						var error = get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")
						match error:
							ERR_CANT_OPEN:
								printerr("Cannot open the scene to the main menu.")
							ERR_CANT_CREATE:
								printerr("Cannot instantiate the main menu.")
					# Enter the main stage. (FIXME: Enter the character selection
					# menu once it has been implemented.)
					elif ready_button.visible and event.button_index == JOY_START:
						var error = get_tree().change_scene("res://stages/base/Stage.tscn")
						match error:
							ERR_CANT_OPEN:
								printerr("Cannot open the scene to the stage.")
							ERR_CANT_CREATE:
								printerr("Cannot instantiate the stage.")
				
				elif event.device == 1:
					# Assign the second controller to player 1 if under devices,
					# or back to devices if under player 2.
					if event.button_index == JOY_DPAD_LEFT:
						if controller2.get_parent().name == "Devices":
							if player1.get_child_count() == 1:
								move_device_to_column(controller2, player1)
								change_device_number("p1_", event.device)
						elif controller2.get_parent().name == "Player2":
							move_device_to_column(controller2, devices)
					# Assign the second controller to player 2 if under devices, or
					# back to devices if under player 1.
					elif event.button_index == JOY_DPAD_RIGHT:
						if controller2.get_parent().name == "Devices":
							if player2.get_child_count() == 1:
								move_device_to_column(controller2, player2)
								change_device_number("p2_", event.device)
						elif controller2.get_parent().name == "Player1":
							move_device_to_column(controller2, devices)
					
					elif Settings.settings["other"]["control_mode"] == Settings.TWO_PLAYER_SIMULTANEOUS\
					or Settings.settings["other"]["control_mode"] == Settings.TWO_PLAYER_INDIVIDUAL:
						# Go back to the previous menu.
						if event.button_index == JOY_XBOX_B:
							# Reset bindings to default before going back to the
							# main menu.
							for input in Settings.settings["input"].keys():
								ProjectSettings.set_setting("input/" + input,
									Settings.settings["input"][input])
							
							var error = get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")
							match error:
								ERR_CANT_OPEN:
									printerr("Cannot open the scene to the main menu.")
								ERR_CANT_CREATE:
									printerr("Cannot instantiate the stage.")
						# Enter the main stage. (FIXME: Enter the character selection
						# menu once it has been implemented.)
						elif ready_button.visible and event.button_index == JOY_START:
							var error = get_tree().change_scene("res://stages/base/Stage.tscn")
							match error:
								ERR_CANT_OPEN:
									printerr("Cannot open the scene to the main menu.")
								ERR_CANT_CREATE:
									printerr("Cannot instantiate the stage.")
			
			if player1.get_child_count() == 2 and player2.get_child_count() == 2:
				ready_button.visible = true
				ready_button.grab_focus()
			else:
				ready_button.visible = false
				ready_button.release_focus()
			$InputTimer.start()

func move_device_to_column(device: Node, column: Node):
	device.get_parent().remove_child(device)
	column.add_child(device)

func change_device_number(player_prefix: String, device: int):
	for input in inputs_snake:
		for j in InputMap.get_action_list(player_prefix + input):
			if j is InputEventJoypadButton or j is InputEventJoypadMotion:
				var input_to_change = j
				InputMap.action_erase_event(player_prefix + input, input_to_change)
				input_to_change.device = device
				InputMap.action_add_event(player_prefix + input, input_to_change)

func assign_keyboard_to_player(player_prefix: String):
	if player_prefix == "p1_":
		# Unassign the keyboard from player 2 if it is assigned to them.
		for input in inputs_snake:
			if InputMap.action_has_event("p2_" + input, InputMap.get_action_list("kb_" + input)[0]):
				InputMap.action_erase_event("p2_" + input, InputMap.get_action_list("kb_" + input)[0])
		
		# And assign it to player 1 if it isn't assigned to them.
		for input in inputs_snake:
			if !InputMap.action_has_event("p1_" + input, InputMap.get_action_list("kb_" + input)[0]):
				InputMap.action_add_event("p1_" + input, InputMap.get_action_list("kb_" + input)[0])
	
	elif player_prefix == "p2_":
		# Unassign the keyboard from player 1 if it is assigned to them.
		for input in inputs_snake:
			if InputMap.action_has_event("p1_" + input, InputMap.get_action_list("kb_" + input)[0]):
				InputMap.action_erase_event("p1_" + input, InputMap.get_action_list("kb_" + input)[0])
		
		# And assign it to player 2 if it isn't assigned to them.
		for input in inputs_snake:
			if !InputMap.action_has_event("p2_" + input, InputMap.get_action_list("kb_" + input)[0]):
				InputMap.action_add_event("p2_" + input, InputMap.get_action_list("kb_" + input)[0])

func _on_InputTimer_timeout():
	input_allowed = true

func _on_ReadyButton_pressed():
	var error = get_tree().change_scene("res://stages/base/Stage.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the stage.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")

func _on_BackButton_pressed():
	var error = get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the main menu.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")
