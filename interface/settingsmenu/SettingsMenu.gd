extends MarginContainer

# Shortening node paths to variables.
onready var resolution = $Settings/Panel/ScrollContainer/VBoxContainer/Resolution/ResolutionOptions
onready var framerate = $Settings/Panel/ScrollContainer/VBoxContainer/FramerateLimit/FramerateOptions
onready var vsync = $Settings/Panel/ScrollContainer/VBoxContainer/Vsync/VsyncCheckBox
onready var fullscreen = $Settings/Panel/ScrollContainer/VBoxContainer/Fullscreen/FullscreenCheckbox
onready var borderless = $Settings/Panel/ScrollContainer/VBoxContainer/Borderless/BorderlessCheckBox
onready var master_volume = $Settings/Panel/ScrollContainer/VBoxContainer/MasterVolume/MasterSlider
onready var music_volume = $Settings/Panel/ScrollContainer/VBoxContainer/MusicVolume/MusicSlider
onready var sfx_volume = $Settings/Panel/ScrollContainer/VBoxContainer/SoundEffectsVolume/SfxSlider
onready var menu_volume = $Settings/Panel/ScrollContainer/VBoxContainer/MenuSounds/MenuSlider
onready var control_mode = $Settings/Panel/ScrollContainer/VBoxContainer/ControlMode/OptionButton
onready var keyboard_controls = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls
onready var kb_up = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Up/Button
onready var kb_down = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Down/Button
onready var kb_left = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Left/Button
onready var kb_right = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Right/Button
onready var kb_light_punch = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/LightPunch/Button
onready var kb_heavy_punch = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/HeavyPunch/Button
onready var kb_light_kick = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/LightKick/Button
onready var kb_heavy_kick = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/HeavyKick/Button
onready var kb_block = $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Block/Button
onready var p1_controller_controls = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls
onready var p1_up = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Up/Button
onready var p1_down = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Down/Button
onready var p1_left = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Left/Button
onready var p1_right = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Up/Button
onready var p1_light_punch = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/LightPunch/Button
onready var p1_heavy_punch = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/HeavyPunch/Button
onready var p1_light_kick = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/LightKick/Button
onready var p1_heavy_kick = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/HeavyKick/Button
onready var p1_block = $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Block/Button
onready var p2_controller_controls = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls
onready var p2_up = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Up/Button
onready var p2_down = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Down/Button
onready var p2_left = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Left/Button
onready var p2_right = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Right/Button
onready var p2_light_punch = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/LightPunch/Button
onready var p2_heavy_punch = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/HeavyPunch/Button
onready var p2_light_kick = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/LightKick/Button
onready var p2_heavy_kick = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/HeavyKick/Button
onready var p2_block = $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Block/Button
onready var inputs = ["Up", "Down", "Left", "Right", "LightPunch", "HeavyPunch",
"LightKick", "HeavyKick", "Block"]
# The inputs in snake case
onready var inputs_snake = ["up", "down", "left", "right", "light_punch",
"heavy_punch", "light_kick", "heavy_kick", "block"]

# For changing bindings.
onready var can_change_key = false
onready var action_string = ""
onready var button_to_change = null

# Set up settings menu.
func _ready():
	# Ready the settings with their respective values from the config (or
	# whatever was setup by the config).
	resolution.selected = Settings.settings["video"]["resolution_box"]
	framerate.selected = Settings.settings["video"]["framerate_limit_box"]
	vsync.pressed = OS.vsync_enabled
	fullscreen.pressed = OS.window_fullscreen
	borderless.pressed = OS.window_borderless
	master_volume.value = AudioServer.get_bus_volume_db(0)
	music_volume.value = AudioServer.get_bus_volume_db(1)
	sfx_volume.value = AudioServer.get_bus_volume_db(2)
	menu_volume.value = AudioServer.get_bus_volume_db(3)
	control_mode.selected = Settings.settings["other"]["control_mode"]
	
	mark_bindings()
	
	resolution.grab_focus()

func _unhandled_input(event):
	# Fixes a bug where trying to rebind an action to the bottom face button
	# (e.g.A on an Xbox controller or X on a Playstation controller) presses 
	# the binding button again, without assigning the new action. This
	# variable is set to false at the end of the funciton.
	get_tree().get_root().handle_input_locally = true
	
	# Take input for changing bindings.
	if can_change_key:
		# For the keyboard.
		if action_string.match("kb_*"):
			if event is InputEventKey:
				# Cancel the rebind.
				if event.scancode == KEY_ESCAPE:
					mark_bindings("kb")
					action_string = ""
					can_change_key = false
				
				# Go through with the rebind if the key is not F11 or F12.
				elif event.scancode != KEY_F11 or event.scancode != KEY_F12:
					# Delete the previous binding
					if !InputMap.get_action_list(action_string).empty():
						InputMap.action_erase_event(action_string,
							InputMap.get_action_list(action_string)[0])
					
					# Check if the new binding was assigned elsewhere.
					for i in inputs_snake:
						if InputMap.action_has_event("kb_" + i, event):
							InputMap.action_erase_event("kb_" + i, event)
					
					# Add the new binding.
					InputMap.action_add_event(action_string, event)
					
					mark_bindings("kb")
					button_to_change = null
					action_string = ""
					can_change_key = false
		
		# For Player 1.
		if action_string.match("p1_*"):
			# Cancel the rebind from the keyboard.
			if event is InputEventKey:
				if event.scancode == KEY_ESCAPE:
					for action in range(0, InputMap.get_action_list(action_string).size() - 1):
						if InputMap.get_action_list(action_string)[action] is InputEventJoypadButton:
							button_to_change.text = InputMap.get_action_list(action_string)[action].as_text()
					button_to_change = null
					action_string = ""
					can_change_key = false
			
			if event is InputEventJoypadButton:
				if event.device == 0:
					# Cancel the rebind from P1's controller
					if event.button_index == JOY_START:
						for action in range(0, InputMap.get_action_list(action_string).size() - 1):
							if InputMap.get_action_list(action_string)[action] is InputEventJoypadButton:
								button_to_change.text = InputMap.get_action_list(action_string)[action].as_text()
						button_to_change = null
						action_string = ""
						can_change_key = false
					
					# Go through with the rebind.
					
					# Delete the previous binding.
					if !InputMap.get_action_list(action_string).empty():
						for i in range(0, InputMap.get_action_list(action_string).size() - 1):
							if InputMap.get_action_list(action_string)[i] is InputEventJoypadButton:
								InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[i])
					
					# Check if the new binding was assigned elsewhere.
					for i in inputs_snake:
						if InputMap.action_has_event("p1_" + i, event):
							InputMap.action_erase_event("p1_" + i, event)
					
					# Add the new binding.
					InputMap.action_add_event(action_string, event)
					
					mark_bindings("p1")
					button_to_change = null
					action_string = ""
					can_change_key = false
					
		# For Player 2.
		if action_string.match("p2_*"):
			# Cancel the rebind.
			if event.scancode == KEY_ESCAPE or event.button_index == JOY_START:
				for action in range(0, InputMap.get_action_list(action_string).size() - 1):
					if InputMap.get_action_list(action_string)[action] is InputEventJoypadButton:
						button_to_change.text = InputMap.get_action_list(action_string)[action].as_text()
				button_to_change = null
				action_string = ""
				can_change_key = false
			
			# Go through with the rebind.
			if event is InputEventJoypadButton:
				if event.device == 1:
					# Delete the previous binding.
					if !InputMap.get_action_list(action_string).empty():
						for i in range(0, InputMap.get_action_list(action_string).size() - 1):
							if InputMap.get_action_list(action_string)[i] is InputEventJoypadButton:
								InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[i])
					
					# Check if the new binding was assigned elsewhere.
					for i in inputs_snake:
						if InputMap.action_has_event("p2_" + i, event):
							InputMap.action_erase_event("p2_" + i, event)
					
					# Add the new binding.
					InputMap.action_add_event(action_string, event)
					
					mark_bindings("p2")
					button_to_change = null
					action_string = ""
					can_change_key = false
	
	# Fixes a bug where trying to rebind an action to the bottom face button (e.g.
	# A on an Xbox controller or X on a Playstation controller) presses the button
	# again, without assigning the new action
	get_tree().get_root().handle_input_locally = false

# Switches resolution.
func _on_ResolutionOptions_item_selected(ID):
	# Native Resolution
	if ID == 0:
		OS.window_size = OS.get_screen_size(0)
		get_tree().get_root().size = OS.get_screen_size(0)
	# Any other resolution (formatted as <width>x<height>)
	else:
		var resolution_regex = RegEx.new()
		resolution_regex.compile("^(\\d+)x(\\d+)$")
		var result = resolution_regex.search(resolution.get_item_text(ID))
		var resolution_width = OS.get_screen_size(0).x
		var resolution_height = OS.get_screen_size(0).y
		if result\
			and result.strings[1] <= resolution_width\
			and result.strings[2] <= resolution_height:
					resolution_width = result.strings[1]
					resolution_height = result.strings[2]
					OS.window_size = Vector2(resolution_width, resolution_height)
					get_tree().get_root().size = Vector2(resolution_width, resolution_height)
		else:
			OS.window_size = OS.get_screen_size(0)
			get_tree().get_root().size = OS.get_screen_size(0)
			ID = 0
			resolution.selected = ID
	
	Settings.settings["video"]["resolution"] = resolution.get_item_text(ID)
	Settings.settings["video"]["resolution_box"] = ID
	Settings.save_settings()

# Switches target framerate.
func _on_FramerateOptions_item_selected(ID):
	Engine.target_fps = int(framerate.get_item_text(ID))
	Settings.save_settings()

# Toggles Vsync.
func _on_VsyncCheckBox_toggled(button_pressed):
	if button_pressed:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false
	Settings.save_settings()

# Toggles fullscreen.
func _on_FullscreenCheckbox_toggled(button_pressed):
	if button_pressed:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
	Settings.save_settings()

# Toggles borderless window.
func _on_BorderlessCheckBox_toggled(button_pressed):
	if button_pressed:
		OS.window_borderless = true
	else:
		OS.window_borderless = false
	Settings.save_settings()

# Resets video settings to their default settings.
func _on_Video_ResetToDefault_pressed():
	for video_setting in Settings.settings["video"].keys():
		Settings.settings["video"][video_setting] = Settings.default_settings["video"][video_setting]
	Settings.save_settings()
	
	OS.window_size = OS.get_screen_size(0)
	get_tree().get_root().size = OS.get_screen_size(0)
	resolution.selected = Settings.default_settings["video"]["resolution_box"]
	
	Engine.target_fps = Settings.default_settings["video"]["framerate_limit"]
	framerate.selected = Settings.default_settings["video"]["framerate_limit_box"]
	
	vsync.pressed = Settings.default_settings["video"]["vsync"]
	OS.vsync_enabled = Settings.default_settings["video"]["vsync"]
	
	fullscreen.pressed = Settings.default_settings["video"]["fullscreen"]
	OS.window_fullscreen = Settings.default_settings["video"]["fullscreen"]
	
	borderless.pressed = Settings.default_settings["video"]["borderless"]
	OS.window_borderless = Settings.default_settings["video"]["borderless"]

# Changes the master volume.
func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	Settings.save_settings()

# Changes the music volume.
func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	Settings.save_settings()

# Changes the sound effects volume.
func _on_SfxSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	Settings.save_settings()

# Changes the menu sound effects volume.
func _on_MenuSlider_value_changed(value):
	AudioServer.set_bus_volume_db(3, value)
	Settings.save_settings()

func _on_Audio_ResetToDefault_pressed():
	var bus = 0
	for audio_setting in Settings.settings["audio"].keys():
		Settings.settings["audio"][audio_setting] = Settings.default_settings["audio"][audio_setting]
		AudioServer.set_bus_volume_db(bus, Settings.default_settings["audio"][audio_setting])
		bus += 1
	Settings.save_settings()
	
	master_volume = AudioServer.get_bus_volume_db(0)
	music_volume = AudioServer.get_bus_volume_db(1)
	sfx_volume = AudioServer.get_bus_volume_db(2)
	menu_volume = AudioServer.get_bus_volume_db(3)

# Set the menu control mode.
func _on_ControlMode_OptionButton_item_selected(ID):
	Settings.settings["other"]["control_mode"] = ID
	Settings.save_settings()
	Settings.set_control_mode()

# Mark the text of the binding buttons with the bindings they have.
func mark_bindings(device = null):
	var k = 0
	
	if device == null or device == "kb":
		# Set the text for the keyboard controls.
		for input in inputs:
			if !InputMap.get_action_list("kb_" + inputs_snake[k]).empty():
				get_node("Settings/Panel/ScrollContainer/VBoxContainer/KBControls/"
				+ input + "/Button").text = InputMap.get_action_list("kb_" + inputs_snake[k])[0].as_text()
			else:
				get_node("Settings/Panel/ScrollContainer/VBoxContainer/KBControls/"
				+ input + "/Button").text = "No binding."
			k += 1
		k = 0
	
	var l = 0
	if device == null or device == "p1":
		# Set the text for player 1's controls
		for input in inputs:
			while l <= InputMap.get_action_list("p1_" + inputs_snake[k]).size() - 1:
				if InputMap.get_action_list("p1_" + inputs_snake[k])[l].get_class() == "InputEventJoypadButton":
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/"
						+ input + "/Button").text = Input.get_joy_button_string(
						InputMap.get_action_list("p1_" + inputs_snake[k])[l].button_index)
					l = InputMap.get_action_list("p1_" + inputs_snake[k]).size() - 1
				else:
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/"
						+ input + "/Button").text = "No binding."
				l += 1
			l = 0
			k += 1
		k = 0
	
	if device == null or device == "p2":
		# Set the text for player 2's controls
		for input in inputs:
			while l <= InputMap.get_action_list("p2_" + inputs_snake[k]).size() - 1:
				if InputMap.get_action_list("p2_" + inputs_snake[k])[l].get_class() == "InputEventJoypadButton":
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/"
						+ input + "/Button").text = Input.get_joy_button_string(
						InputMap.get_action_list("p2_" + inputs_snake[k])[l].button_index)
					l = InputMap.get_action_list("p2_" + inputs_snake[k]).size() - 1
				else:
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/"
						+ input + "/Button").text = "No binding."
				l += 1
			l = 0
			k += 1
		k = 0

# Reset all bindings to their default settings.
func _on_ResetAllBindingsToDefault_pressed():
	for input in Settings.settings["input"].keys():
		Settings.settings["input"][input] = Settings.default_settings["input"][input]
		ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings()

# Reset default keyboard bindings to their default settings.
func _on_KB_ResetToDefault_pressed():
	for input in Settings.settings["input"].keys():
		if input.match("kb_*"):
			Settings.settings["input"][input] = Settings.default_settings["input"][input]
			ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings("kb")

# Reset Player 1's bindings back to their default settings.
func _on_P1_ResetToDefault_pressed():
	for input in Settings.settings["input"].keys():
		if input.match("p1_*"):
			Settings.settings["input"][input] = Settings.default_settings["input"][input]
			ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings("p1")

# Reset Player 2's bindings back to their default settings.
func _on_P2_ResetToDefault_pressed():
	for input in Settings.settings["input"].keys():
		if input.match("p2_*"):
			Settings.settings["input"][input] = Settings.default_settings["input"][input]
			ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings("p2")

# Ready the KB Up button for changing it's binding.
func _on_KB_Up_Button_pressed():
	action_string = "kb_up"
	kb_up.text = "Press a key to rebind..."
	button_to_change = kb_up
	can_change_key = true

func _on_KB_Down_Button_pressed():
	action_string = "kb_down"
	kb_down.text = "Press a key to rebind..."
	button_to_change = kb_down
	can_change_key = true

func _on_KB_Left_Button_pressed():
	action_string = "kb_right"
	kb_left.text = "Press a key to rebind..."
	button_to_change = kb_down
	can_change_key = true

func _on_KB_Right_Button_pressed():
	action_string = "kb_Right"
	kb_right.text = "Press a key to rebind..."
	button_to_change = kb_right
	can_change_key = true

func _on_KB_LightPunch_Button_pressed():
	action_string = "kb_light_punch"
	kb_light_punch.text = "Press a key to rebind..."
	button_to_change = kb_light_punch
	can_change_key = true

func _on_KB_HeavyPunch_Button_pressed():
	action_string = "kb_heavy_punch"
	kb_heavy_punch.text = "Press a key to rebind..."
	button_to_change = kb_heavy_punch
	can_change_key = true

func _on_KB_LightKick_Button_pressed():
	action_string = "kb_light_kick"
	kb_light_kick.text = "Press a key to rebind..."
	button_to_change = kb_light_kick
	can_change_key = true

func _on_KB_HeavyKick_Button_pressed():
	action_string = "kb_heavy_kick"
	kb_heavy_punch.text = "Press a key to rebind..."
	button_to_change = kb_heavy_kick
	can_change_key = true

func _on_KB_Block_Button_pressed():
	action_string = "kb_block"
	kb_block.text = "Press a key to rebind..."
	button_to_change = kb_block
	can_change_key = true

func _on_P1_Up_Button_pressed():
	action_string = "p1_up"
	p1_up.text = "Press a key to rebind..."
	button_to_change = p1_up
	can_change_key = true

func _on_P1_Down_Button_pressed():
	action_string = "p1_down"
	p1_down.text = "Press a key to rebind..."
	button_to_change = p1_down
	can_change_key = true

func _on_P1_Left_Button_pressed():
	action_string = "p1_left"
	p1_left.text = "Press a key to rebind..."
	button_to_change = p1_left
	can_change_key = true

func _on_P1_Right_Button_pressed():
	action_string = "p1_right"
	p1_right.text = "Press a key to rebind..."
	button_to_change = p1_right
	can_change_key = true

func _on_P1_LightPunch_Button_pressed():
	action_string = "p1_light_punch"
	p1_light_punch.text = "Press a key to rebind..."
	button_to_change = p1_light_punch
	can_change_key = true

func _on_P1_HeavyPunch_Button_pressed():
	action_string = "p1_heavy_punch"
	p1_heavy_punch.text = "Press a key to rebind..."
	button_to_change = p1_heavy_punch
	can_change_key = true

func _on_P1_LightKick_Button_pressed():
	action_string = "p1_light_kick"
	p1_light_kick.text = "Press a key to rebind..."
	button_to_change = p1_light_kick
	can_change_key = true

func _on_P1_HeavyKick_Button_pressed():
	action_string = "p1_heavy_kick"
	p1_heavy_kick.text = "Press a key to rebind..."
	button_to_change = p1_heavy_kick
	can_change_key = true

func _on_P1_Block_Button_pressed():
	action_string = "p1_block"
	p1_block.text = "Press a key to rebind..."
	button_to_change = p1_block
	can_change_key = true

func _on_P2_Up_Button_pressed():
	action_string = "p2_up"
	p2_up.text = "Press a key to rebind..."
	button_to_change = p2_up
	can_change_key = true

func _on_P2_Down_Button_pressed():
	action_string = "p2_down"
	p2_down.text = "Press a key to rebind..."
	button_to_change = p2_down
	can_change_key = true

func _on_P2_Left_Button_pressed():
	action_string = "p2_left"
	p2_left.text = "Press a key to rebind..."
	button_to_change = p2_left
	can_change_key = true

func _on_P2_Right_Button_pressed():
	action_string = "p2_right"
	p2_right.text = "Press a key to rebind..."
	button_to_change = p2_right
	can_change_key = true

func _on_P2_LightPunch_Button_pressed():
	action_string = "p2_light_punch"
	p2_light_punch.text = "Press a key to rebind..."
	button_to_change = p2_light_punch
	can_change_key = true

func _on_P2_HeavyPunch_Button_pressed():
	action_string = "p2_heavy_punch"
	p2_heavy_punch.text = "Press a key to rebind..."
	button_to_change = p2_heavy_punch
	can_change_key = true

func _on_P2_LightKick_Button_pressed():
	action_string = "p2_light_kick"
	p2_light_kick.text = "Press a key to rebind..."
	button_to_change = p2_light_kick
	can_change_key = true

func _on_P2_HeavyKick_Button_pressed():
	action_string = "p2_heavy_kick"
	p2_heavy_kick.text = "Press a key to rebind..."
	button_to_change = p2_heavy_kick
	can_change_key = true

func _on_P2_Block_Button_pressed():
	action_string = "p2_block"
	p2_block.text = "Press a key to rebind..."
	button_to_change = p2_block
	can_change_key = true
