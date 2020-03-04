extends MarginContainer

# Shortening node paths to variables.
onready var resolution = $Settings/Panel/VideoSettings/HBoxContainer/Resolution/ResolutionOptions
onready var framerate = $Settings/Panel/VideoSettings/HBoxContainer/FramerateLimit/FramerateOptions
onready var vsync = $Settings/Panel/VideoSettings/HBoxContainer/Vsync/VsyncCheckBox
onready var fullscreen = $Settings/Panel/VideoSettings/HBoxContainer/Fullscreen/FullscreenCheckbox
onready var borderless = $Settings/Panel/VideoSettings/HBoxContainer/Borderless/BorderlessCheckBox
onready var master_volume = $Settings/Panel/AudioSettings/HBoxContainer/MasterVolume/MasterSlider
onready var music_volume = $Settings/Panel/AudioSettings/HBoxContainer/MusicVolume/MusicSlider
onready var sfx_volume = $Settings/Panel/AudioSettings/HBoxContainer/SoundEffectsVolume/SfxSlider
onready var menu_volume = $Settings/Panel/AudioSettings/HBoxContainer/MenuSounds/MenuSlider
onready var control_mode = $Settings/Panel/ControlSettings/HBoxContainer/ControlMode/OptionButton
onready var keyboard_controls = $Settings/Panel/ControlSettings/HBoxContainer/KBControls
onready var kb_up = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/Up/Button
onready var kb_down = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/Down/Button
onready var kb_left = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/Left/Button
onready var kb_right = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/Right/Button
onready var kb_light_punch = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/LightPunch/Button
onready var kb_heavy_punch = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/HeavyPunch/Button
onready var kb_light_kick = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/LightKick/Button
onready var kb_heavy_kick = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/HeavyKick/Button
onready var kb_block = $Settings/Panel/ControlSettings/HBoxContainer/KBControls/Block/Button
onready var p1_controller_controls = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls
onready var p1_up = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/Up/Button
onready var p1_down = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/Down/Button
onready var p1_left = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/Left/Button
onready var p1_right = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/Right/Button
onready var p1_light_punch = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/LightPunch/Button
onready var p1_heavy_punch = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/HeavyPunch/Button
onready var p1_light_kick = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/LightKick/Button
onready var p1_heavy_kick = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/HeavyKick/Button
onready var p1_block = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls/Block/Button
onready var p2_controller_controls = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls
onready var p2_up = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/Up/Button
onready var p2_down = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/Down/Button
onready var p2_left = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/Left/Button
onready var p2_right = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/Right/Button
onready var p2_light_punch = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/LightPunch/Button
onready var p2_heavy_punch = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/HeavyPunch/Button
onready var p2_light_kick = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/LightKick/Button
onready var p2_heavy_kick = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/HeavyKick/Button
onready var p2_block = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls/Block/Button

# Set up settings menu.
func _ready():
	# Set up the tabs for the settings categories
	$Settings/SettingsCategories.current_tab = 0
	$Settings/Panel/AudioSettings.hide()
	$Settings/Panel/ControlSettings.hide()
	$Settings/Panel/VideoSettings.show()
	
	# Set up the tabs for the control settings.
	$Settings/Panel/ControlSettings/HBoxContainer/PlayerTabs.current_tab = 0
	p1_controller_controls.hide()
	p2_controller_controls.hide()
	keyboard_controls.show()
	
	# Ready the settings with their respective values from the config.
	resolution.selected = Settings.settings["video"]["resolution_box"]
	framerate.selected = Settings.settings["video"]["framerate_box"]
	vsync.pressed = Settings.settings["video"]["vsync"]

# Switches tabs.
func _on_SettingsCategories_tab_changed(tab):
	match tab:
		0:
			$Settings/Panel/AudioSettings.hide()
			$Settings/Panel/ControlSettings.hide()
			$Settings/Panel/VideoSettings.show()
		1:
			$Settings/Panel/VideoSettings.hide()
			$Settings/Panel/ControlSettings.hide()
			$Settings/Panel/AudioSettings.show()
		2:
			$Settings/Panel/VideoSettings.hide()
			$Settings/Panel/AudioSettings.hide()
			$Settings/Panel/ControlSettings.show()

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
		var result = resolution_regex.search(resolution.get_item_text(resolution.selected))
		var resolution_width = OS.get_screen_size()
		var resolution_height = OS.get_screen_size()
		if result:
			resolution_width = result.strings[1]
			resolution_height = result.strings[2]
			OS.window_size = Vector2(resolution_width, resolution_height)
			get_tree().get_root().size = Vector2(resolution_width, resolution_height)
	
	Settings.settings["video"]["resolution"] = resolution.get_item_text(resolution.selected)
	Settings.settings["video"]["resolution_box"] = resolution.selected
	Settings.save_settings()

# Switches target framerate.
func _on_FramerateOptions_item_selected(_ID):
	Engine.target_fps = int(framerate.get_item_text(framerate.selected))
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

# Changes the binding categories for keyboard/controller players.
func _on_PlayerTabs_tab_changed(tab):
	match tab:
		# Show keyboard controls.
		0:
			p1_controller_controls.hide()
			p2_controller_controls.hide()
			keyboard_controls.show()
		# Show player 1 controlls.
		1:
			keyboard_controls.hide()
			p2_controller_controls.hide()
			p1_controller_controls.show()
		# Show player 2 controlls.
		2:
			keyboard_controls.hide()
			p1_controller_controls.hide()
			p2_controller_controls.show()
