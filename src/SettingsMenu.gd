extends MarginContainer

const inputs = [
	"Up", "Down", "Left", "Right", "LightPunch", "HeavyPunch", "LightKick", "HeavyKick", "Block"
]
# The inputs in snake case
const inputs_snake = [
	"up", "down", "left", "right", "light_punch", "heavy_punch", "light_kick", "heavy_kick", "block"
]

export (NodePath) var previous_menu
export (NodePath) var previous_focus

# Shortening node paths to variables.
onready var _resolution := $Settings/Panel/ScrollContainer/VBoxContainer/Resolution/ResolutionOptions
onready var _framerate := $Settings/Panel/ScrollContainer/VBoxContainer/FramerateLimit/FramerateOptions
onready var _vsync := $Settings/Panel/ScrollContainer/VBoxContainer/Vsync/VsyncCheckBox
onready var _fullscreen := $Settings/Panel/ScrollContainer/VBoxContainer/Fullscreen/FullscreenCheckbox
onready var _borderless := $Settings/Panel/ScrollContainer/VBoxContainer/Borderless/BorderlessCheckBox
onready var _master_volume := $Settings/Panel/ScrollContainer/VBoxContainer/MasterVolume/MasterSlider
onready var _music_volume := $Settings/Panel/ScrollContainer/VBoxContainer/MusicVolume/MusicSlider
onready var _sfx_volume := $Settings/Panel/ScrollContainer/VBoxContainer/SoundEffectsVolume/SfxSlider
onready var _menu_volume := $Settings/Panel/ScrollContainer/VBoxContainer/MenuSounds/MenuSlider
onready var _control_mode := $Settings/Panel/ScrollContainer/VBoxContainer/ControlMode/OptionButton
onready var _keyboard_controls := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls
onready var _kb_up := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Up/Button
onready var _kb_down := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Down/Button
onready var _kb_left := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Left/Button
onready var _kb_right := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Right/Button
onready var _kb_light_punch := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/LightPunch/Button
onready var _kb_heavy_punch := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/HeavyPunch/Button
onready var _kb_light_kick := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/LightKick/Button
onready var _kb_heavy_kick := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/HeavyKick/Button
onready var _kb_block := $Settings/Panel/ScrollContainer/VBoxContainer/KBControls/Block/Button
onready var _p1_controller_controls := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls
onready var _p1_up := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Up/Button
onready var _p1_down := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Down/Button
onready var _p1_left := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Left/Button
onready var _p1_right := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Right/Button
onready var _p1_light_punch := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/LightPunch/Button
onready var _p1_heavy_punch := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/HeavyPunch/Button
onready var _p1_light_kick := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/LightKick/Button
onready var _p1_heavy_kick := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/HeavyKick/Button
onready var _p1_block := $Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/Block/Button
onready var _p2_controller_controls := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls
onready var _p2_up := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Up/Button
onready var _p2_down := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Down/Button
onready var _p2_left := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Left/Button
onready var _p2_right := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Right/Button
onready var _p2_light_punch := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/LightPunch/Button
onready var _p2_heavy_punch := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/HeavyPunch/Button
onready var _p2_light_kick := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/LightKick/Button
onready var _p2_heavy_kick := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/HeavyKick/Button
onready var _p2_block := $Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/Block/Button

# For changing bindings.
onready var _can_change_key := false
onready var _action_string := ""
onready var _button_to_change: Button = null


# Set up settings menu.
func _ready() -> void:
	# Ready the settings with their respective values from the config (or
	# whatever was setup by the config).
	_resolution.selected = Settings.settings["video"]["resolution_box"]
	_framerate.selected = Settings.settings["video"]["framerate_limit_box"]
	_vsync.pressed = OS.vsync_enabled
	_fullscreen.pressed = OS.window_fullscreen
	_borderless.pressed = OS.window_borderless
	_master_volume.value = AudioServer.get_bus_volume_db(0)
	_music_volume.value = AudioServer.get_bus_volume_db(1)
	_sfx_volume.value = AudioServer.get_bus_volume_db(2)
	_menu_volume.value = AudioServer.get_bus_volume_db(3)
	_control_mode.selected = Settings.settings["other"]["control_mode"]
	
	mark_bindings()
	
	_resolution.grab_focus()


func _input(event: InputEvent) -> void:
	# Fixes a bug where trying to rebind an action to the bottom face button
	# (e.g.A on an Xbox controller or X on a Playstation controller) presses 
	# the binding button again, without assigning the new action. This
	# variable is set to false at the end of the funciton.
	get_tree().get_root().handle_input_locally = true
	
	# Take input for changing bindings.
	if _can_change_key:
		# For the keyboard.
		if _action_string.match("kb_*"):
			if event is InputEventKey:
				# Cancel the rebind.
				if event.scancode == KEY_ESCAPE:
					mark_bindings("kb")
					_action_string = ""
					_can_change_key = false
				
				# Go through with the rebind if the key is not F11 or F12.
				elif event.scancode != KEY_F11 or event.scancode != KEY_F12:
					# Delete the previous binding
					if ! InputMap.get_action_list(_action_string).empty():
						InputMap.action_erase_event(
							_action_string, InputMap.get_action_list(_action_string)[0]
						)
					
					# Check if the new binding was assigned elsewhere.
					for i in inputs_snake:
						if InputMap.action_has_event("kb_" + i, event):
							InputMap.action_erase_event("kb_" + i, event)
					
					# Add the new binding.
					InputMap.action_add_event(_action_string, event)
					
					mark_bindings("kb")
					_button_to_change = null
					_action_string = ""
					_can_change_key = false
		
		# For Player 1.
		if _action_string.match("p1_*"):
			# Cancel the rebind from the keyboard.
			if event is InputEventKey:
				if event.scancode == KEY_ESCAPE:
					for action in range(0, InputMap.get_action_list(_action_string).size() - 1):
						if (
							InputMap.get_action_list(_action_string)[action]
							is InputEventJoypadButton
						):
							_button_to_change.text = InputMap.get_action_list(_action_string)[action].as_text()
					_button_to_change = null
					_action_string = ""
					_can_change_key = false
					
			if event is InputEventJoypadButton:
				if event.device == 0:
					# Cancel the rebind from P1's controller
					if event.button_index == JOY_START:
						for action in range(0, InputMap.get_action_list(_action_string).size() - 1):
							if (
								InputMap.get_action_list(_action_string)[action]
								is InputEventJoypadButton
							):
								_button_to_change.text = InputMap.get_action_list(_action_string)[action].as_text()
						_button_to_change = null
						_action_string = ""
						_can_change_key = false
					
					# Go through with the rebind.
					
					# Delete the previous binding.
					if ! InputMap.get_action_list(_action_string).empty():
						for i in range(0, InputMap.get_action_list(_action_string).size() - 1):
							if InputMap.get_action_list(_action_string)[i] is InputEventJoypadButton:
								InputMap.action_erase_event(
									_action_string, InputMap.get_action_list(_action_string)[i]
								)
					
					# Check if the new binding was assigned elsewhere.
					for i in inputs_snake:
						if InputMap.action_has_event("p1_" + i, event):
							InputMap.action_erase_event("p1_" + i, event)
					
					# Add the new binding.
					InputMap.action_add_event(_action_string, event)
					
					mark_bindings("p1")
					_button_to_change = null
					_action_string = ""
					_can_change_key = false
		
		# For Player 2.
		if _action_string.match("p2_*"):
			# Cancel the rebind.
			if event.scancode == KEY_ESCAPE or event.button_index == JOY_START:
				for action in range(0, InputMap.get_action_list(_action_string).size() - 1):
					if InputMap.get_action_list(_action_string)[action] is InputEventJoypadButton:
						_button_to_change.text = InputMap.get_action_list(_action_string)[action].as_text()
				_button_to_change = null
				_action_string = ""
				_can_change_key = false
			
			# Go through with the rebind.
			if event is InputEventJoypadButton:
				if event.device == 1:
					# Delete the previous binding.
					if ! InputMap.get_action_list(_action_string).empty():
						for i in range(0, InputMap.get_action_list(_action_string).size() - 1):
							if InputMap.get_action_list(_action_string)[i] is InputEventJoypadButton:
								InputMap.action_erase_event(
									_action_string, InputMap.get_action_list(_action_string)[i]
								)
					
					# Check if the new binding was assigned elsewhere.
					for i in inputs_snake:
						if InputMap.action_has_event("p2_" + i, event):
							InputMap.action_erase_event("p2_" + i, event)
					
					# Add the new binding.
					InputMap.action_add_event(_action_string, event)
				
					mark_bindings("p2")
					_button_to_change = null
					_action_string = ""
					_can_change_key = false
	
	else:
		if event.button_index == JOY_START:
			visible = false
			get_node(previous_menu).visible = true
			get_node(previous_focus).grab_focus()
	
	# Fixes a bug where trying to rebind an action to the bottom face button (e.g.
	# A on an Xbox controller or X on a Playstation controller) presses the button
	# again, without assigning the new action
	get_tree().get_root().handle_input_locally = false


# Switches resolution.
func _on_ResolutionOptions_item_selected(ID: int) -> void:
	# Native Resolution
	if ID == 0:
		OS.window_size = OS.get_screen_size(0)
		get_tree().get_root().size = OS.get_screen_size(0)
	# Any other resolution (formatted as <width>x<height>)
	else:
		var resolution_regex = RegEx.new()
		resolution_regex.compile("^(\\d+)x(\\d+)$")
		var result = resolution_regex.search(_resolution.get_item_text(ID))
		var resolution_width = OS.get_screen_size(0).x
		var resolution_height = OS.get_screen_size(0).y
		if (
			result
			and float(result.strings[1]) <= resolution_width
			and float(result.strings[2]) <= resolution_height
		):
			resolution_width = float(result.strings[1])
			resolution_height = float(result.strings[2])
			OS.window_size = Vector2(resolution_width, resolution_height)
			get_tree().get_root().size = Vector2(resolution_width, resolution_height)
		else:
			OS.window_size = OS.get_screen_size(0)
			get_tree().get_root().size = OS.get_screen_size(0)
			ID = 0
			_resolution.selected = ID
	
	Settings.settings["video"]["_resolution"] = _resolution.get_item_text(ID)
	Settings.settings["video"]["resolution_box"] = ID
	Settings.save_settings()


# Switches target framerate.
func _on_FramerateOptions_item_selected(ID: int) -> void:
	Engine.target_fps = int(_framerate.get_item_text(ID))
	Settings.save_settings()


# Toggles Vsync.
func _on_VsyncCheckBox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false
	Settings.save_settings()


# Toggles fullscreen.
func _on_FullscreenCheckbox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
	Settings.save_settings()


# Toggles borderless window.
func _on_BorderlessCheckBox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		OS.window_borderless = true
	else:
		OS.window_borderless = false
	Settings.save_settings()


# Resets video settings to their default settings.
func _on_Video_ResetToDefault_pressed() -> void:
	for video_setting in Settings.settings["video"]:
		Settings.settings["video"][video_setting] = Settings.default_settings["video"][video_setting]
	Settings.save_settings()
	
	OS.window_size = OS.get_screen_size(0)
	get_tree().get_root().size = OS.get_screen_size(0)
	_resolution.selected = Settings.default_settings["video"]["resolution_box"]
	
	Engine.target_fps = Settings.default_settings["video"]["framerate_limit"]
	_framerate.selected = Settings.default_settings["video"]["framerate_limit_box"]
	
	_vsync.pressed = Settings.default_settings["video"]["vsync"]
	OS.vsync_enabled = Settings.default_settings["video"]["vsync"]
	
	_fullscreen.pressed = Settings.default_settings["video"]["fullscreen"]
	OS.window_fullscreen = Settings.default_settings["video"]["fullscreen"]
	
	_borderless.pressed = Settings.default_settings["video"]["borderless"]
	OS.window_borderless = Settings.default_settings["video"]["borderless"]


# Changes the master volume.
func _on_MasterSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	Settings.save_settings()


# Changes the music volume.
func _on_MusicSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	Settings.save_settings()


# Changes the sound effects volume.
func _on_SfxSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	Settings.save_settings()


# Changes the menu sound effects volume.
func _on_MenuSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(3, value)
	Settings.save_settings()


func _on_Audio_ResetToDefault_pressed() -> void:
	var bus = 0
	for audio_setting in Settings.settings["audio"].keys():
		Settings.settings["audio"][audio_setting] = Settings.default_settings["audio"][audio_setting]
		AudioServer.set_bus_volume_db(bus, Settings.default_settings["audio"][audio_setting])
		bus += 1
	Settings.save_settings()

	_master_volume.value = AudioServer.get_bus_volume_db(0)
	_music_volume.value = AudioServer.get_bus_volume_db(1)
	_sfx_volume.value = AudioServer.get_bus_volume_db(2)
	_menu_volume.value = AudioServer.get_bus_volume_db(3)


# Set the menu control mode.
func _on_ControlMode_OptionButton_item_selected(ID) -> void:
	Settings.settings["other"]["control_mode"] = ID
	Settings.save_settings()
	Settings.set_control_mode()


# Mark the text of the binding buttons with the bindings they have.
func mark_bindings(device = null) -> void:
	var k = 0

	if device == null or device == "kb":
		# Set the text for the keyboard controls.
		for input in inputs:
			if ! InputMap.get_action_list("kb_" + inputs_snake[k]).empty():
				get_node("Settings/Panel/ScrollContainer/VBoxContainer/KBControls/" + input + "/Button").text = InputMap.get_action_list("kb_" + inputs_snake[k])[0].as_text()
			else:
				get_node("Settings/Panel/ScrollContainer/VBoxContainer/KBControls/" + input + "/Button").text = "No binding."
			k += 1
		k = 0

	var l = 0
	if device == null or device == "p1":
		# Set the text for player 1's controls
		for input in inputs:
			while l <= InputMap.get_action_list("p1_" + inputs_snake[k]).size() - 1:
				if (
					InputMap.get_action_list("p1_" + inputs_snake[k])[l].get_class()
					== "InputEventJoypadButton"
				):
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/" + input + "/Button").text = Input.get_joy_button_string(
						InputMap.get_action_list("p1_" + inputs_snake[k])[l].button_index
					)
					l = InputMap.get_action_list("p1_" + inputs_snake[k]).size() - 1
				else:
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P1ControllerControls/" + input + "/Button").text = "No binding."
				l += 1
			l = 0
			k += 1
		k = 0

	if device == null or device == "p2":
		# Set the text for player 2's controls
		for input in inputs:
			while l <= InputMap.get_action_list("p2_" + inputs_snake[k]).size() - 1:
				if (
					InputMap.get_action_list("p2_" + inputs_snake[k])[l].get_class()
					== "InputEventJoypadButton"
				):
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/" + input + "/Button").text = Input.get_joy_button_string(
						InputMap.get_action_list("p2_" + inputs_snake[k])[l].button_index
					)
					l = InputMap.get_action_list("p2_" + inputs_snake[k]).size() - 1
				else:
					get_node("Settings/Panel/ScrollContainer/VBoxContainer/P2ControllerControls/" + input + "/Button").text = "No binding."
				l += 1
			l = 0
			k += 1
		k = 0


# Reset all bindings to their default settings.
func _on_ResetAllBindingsToDefault_pressed() -> void:
	for input in Settings.settings["input"].keys():
		Settings.settings["input"][input] = Settings.default_settings["input"][input]
		ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings()


# Reset default keyboard bindings to their default settings.
func _on_KB_ResetToDefault_pressed() -> void:
	for input in Settings.settings["input"].keys():
		if input.match("kb_*"):
			Settings.settings["input"][input] = Settings.default_settings["input"][input]
			ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings("kb")


# Reset Player 1's bindings back to their default settings.
func _on_P1_ResetToDefault_pressed() -> void:
	for input in Settings.settings["input"].keys():
		if input.match("p1_*"):
			Settings.settings["input"][input] = Settings.default_settings["input"][input]
			ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings("p1")


# Reset Player 2's bindings back to their default settings.
func _on_P2_ResetToDefault_pressed() -> void:
	for input in Settings.settings["input"].keys():
		if input.match("p2_*"):
			Settings.settings["input"][input] = Settings.default_settings["input"][input]
			ProjectSettings.set("input/" + input, Settings.default_settings["input"][input])
	Settings.save_settings()
	
	mark_bindings("p2")


# Ready the KB Up button for changing it's binding.
func _on_KB_Up_Button_pressed() -> void:
	_action_string = "kb_up"
	_kb_up.text = "Press a key to rebind..."
	_button_to_change = _kb_up
	_can_change_key = true


func _on_KB_Down_Button_pressed() -> void:
	_action_string = "kb_down"
	_kb_down.text = "Press a key to rebind..."
	_button_to_change = _kb_down
	_can_change_key = true


func _on_KB_Left_Button_pressed() -> void:
	_action_string = "kb_left"
	_kb_left.text = "Press a key to rebind..."
	_button_to_change = _kb_left
	_can_change_key = true


func _on_KB_Right_Button_pressed() -> void:
	_action_string = "kb_right"
	_kb_right.text = "Press a key to rebind..."
	_button_to_change = _kb_right
	_can_change_key = true


func _on_KB_LightPunch_Button_pressed() -> void:
	_action_string = "kb_light_punch"
	_kb_light_punch.text = "Press a key to rebind..."
	_button_to_change = _kb_light_punch
	_can_change_key = true


func _on_KB_HeavyPunch_Button_pressed() -> void:
	_action_string = "kb_heavy_punch"
	_kb_heavy_punch.text = "Press a key to rebind..."
	_button_to_change = _kb_heavy_punch
	_can_change_key = true


func _on_KB_LightKick_Button_pressed() -> void:
	_action_string = "kb_light_kick"
	_kb_light_kick.text = "Press a key to rebind..."
	_button_to_change = _kb_light_kick
	_can_change_key = true


func _on_KB_HeavyKick_Button_pressed() -> void:
	_action_string = "kb_heavy_kick"
	_kb_heavy_kick.text = "Press a key to rebind..."
	_button_to_change = _kb_heavy_kick
	_can_change_key = true


func _on_KB_Block_Button_pressed() -> void:
	_action_string = "kb_block"
	_kb_block.text = "Press a key to rebind..."
	_button_to_change = _kb_block
	_can_change_key = true


func _on_P1_Up_Button_pressed() -> void:
	_action_string = "p1_up"
	_p1_up.text = "Press a key to rebind..."
	_button_to_change = _p1_up
	_can_change_key = true


func _on_P1_Down_Button_pressed() -> void:
	_action_string = "p1_down"
	_p1_down.text = "Press a key to rebind..."
	_button_to_change = _p1_down
	_can_change_key = true


func _on_P1_Left_Button_pressed() -> void:
	_action_string = "p1_left"
	_p1_left.text = "Press a key to rebind..."
	_button_to_change = _p1_left
	_can_change_key = true


func _on_P1_Right_Button_pressed() -> void:
	_action_string = "p1_right"
	_p1_right.text = "Press a key to rebind..."
	_button_to_change = _p1_right
	_can_change_key = true


func _on_P1_LightPunch_Button_pressed() -> void:
	_action_string = "p1_light_punch"
	_p1_light_punch.text = "Press a key to rebind..."
	_button_to_change = _p1_light_punch
	_can_change_key = true


func _on_P1_HeavyPunch_Button_pressed() -> void:
	_action_string = "p1_heavy_punch"
	_p1_heavy_punch.text = "Press a key to rebind..."
	_button_to_change = _p1_heavy_punch
	_can_change_key = true


func _on_P1_LightKick_Button_pressed() -> void:
	_action_string = "p1_light_kick"
	_p1_light_kick.text = "Press a key to rebind..."
	_button_to_change = _p1_light_kick
	_can_change_key = true


func _on_P1_HeavyKick_Button_pressed() -> void:
	_action_string = "p1_heavy_kick"
	_p1_heavy_kick.text = "Press a key to rebind..."
	_button_to_change = _p1_heavy_kick
	_can_change_key = true


func _on_P1_Block_Button_pressed() -> void:
	_action_string = "p1_block"
	_p1_block.text = "Press a key to rebind..."
	_button_to_change = _p1_block
	_can_change_key = true


func _on_P2_Up_Button_pressed() -> void:
	_action_string = "p2_up"
	_p2_up.text = "Press a key to rebind..."
	_button_to_change = _p2_up
	_can_change_key = true


func _on_P2_Down_Button_pressed() -> void:
	_action_string = "_p2_down"
	_p2_down.text = "Press a key to rebind..."
	_button_to_change = _p2_down
	_can_change_key = true


func _on_P2_Left_Button_pressed() -> void:
	_action_string = "p2_left"
	_p2_left.text = "Press a key to rebind..."
	_button_to_change = _p2_left
	_can_change_key = true


func _on_P2_Right_Button_pressed() -> void:
	_action_string = "p2_right"
	_p2_right.text = "Press a key to rebind..."
	_button_to_change = _p2_right
	_can_change_key = true


func _on_P2_LightPunch_Button_pressed() -> void:
	_action_string = "p2_light_punch"
	_p2_light_punch.text = "Press a key to rebind..."
	_button_to_change = _p2_light_punch
	_can_change_key = true


func _on_P2_HeavyPunch_Button_pressed() -> void:
	_action_string = "p2_heavy_punch"
	_p2_heavy_punch.text = "Press a key to rebind..."
	_button_to_change = _p2_heavy_punch
	_can_change_key = true


func _on_P2_LightKick_Button_pressed() -> void:
	_action_string = "p2_light_kick"
	_p2_light_kick.text = "Press a key to rebind..."
	_button_to_change = _p2_light_kick
	_can_change_key = true


func _on_P2_HeavyKick_Button_pressed() -> void:
	_action_string = "p2_heavy_kick"
	_p2_heavy_kick.text = "Press a key to rebind..."
	_button_to_change = _p2_heavy_kick
	_can_change_key = true


func _on_P2_Block_Button_pressed() -> void:
	_action_string = "p2_block"
	_p2_block.text = "Press a key to rebind..."
	_button_to_change = _p2_block
	_can_change_key = true


func _on_BackButton_pressed() -> void:
	visible = false
	get_node(previous_menu).visible = true
	get_node(previous_focus).grab_focus()
