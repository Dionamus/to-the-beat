extends MarginContainer

onready var keyboard_controls = $Settings/Panel/ControlSettings/HBoxContainer/KeyboardControls
onready var p1_controller_controls = $Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls
onready var p2_controller_controls = $Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls

# Set up the tabs once loaded.
func _ready():
	$Settings/SettingsCategories.current_tab = 0
	$Settings/Panel/AudioSettings.hide()
	$Settings/Panel/ControlSettings.hide()
	$Settings/Panel/VideoSettings.show()
	
	$Settings/Panel/ControlSettings/HBoxContainer/PlayerTabs.current_tab = 0
	$Settings/Panel/ControlSettings/HBoxContainer/P1ControllerControls.hide()
	$Settings/Panel/ControlSettings/HBoxContainer/P2ControllerControls.hide()
	$Settings/Panel/ControlSettings/HBoxContainer/KBControls.show()

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
	match ID:
		# Native Resolution
		0:
			OS.window_size = OS.get_screen_size(0)
			get_tree().get_root().size = OS.get_screen_size(0)
		# 1920x1080
		1:
			OS.window_size = Vector2(1920, 1080)
			get_tree().get_root().size = Vector2(1920, 1080)
		# 1280x720
		2:
			OS.window_size = Vector2(1280, 720)
			get_tree().get_root().size = Vector2(1280, 720)

# Switches target framerate.
func _on_FramerateOptions_item_selected(ID):
	match ID:
		# No framerate limit
		0:
			Engine.target_fps = 0
		# 30 FPS
		1:
			Engine.target_fps = 30
		# 60 FPS
		2:
			Engine.target_fps = 60
		# 120 FPS
		3:
			Engine.target_fps = 120
		# 144 FPS
		4:
			Engine.target_fps = 144
		# 200 FPS
		5:
			Engine.target_fps = 200
		# 240 FPS
		6:
			Engine.target_fps = 240

# Toggles Vsync.
func _on_VsyncCheckBox_toggled(button_pressed):
	if button_pressed:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false

# Toggles fullscreen.
func _on_FullscreenCheckbox_toggled(button_pressed):
	if button_pressed:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false

# Toggles borderless window.
func _on_BorderlessCheckBox_toggled(button_pressed):
	if button_pressed:
		OS.window_borderless = true
	else:
		OS.window_borderless = false

# Changes the master volume.
func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

# Changes the music volume.
func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)

# Changes the sound effects volume.
func _on_SfxSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)

# Changes the menu sound effects volume.
func _on_MenuSlider_value_changed(value):
	AudioServer.set_bus_volume_db(3, value)

# Changes the binding categories for keyboard/controller players.
func _on_PlayerTabs_tab_changed(tab):
	match tab:
		0:
			p1_controller_controls.hide()
			p2_controller_controls.hide()
			keyboard_controls.show()
		1:
			keyboard_controls.hide()
			p2_controller_controls.hide()
			p1_controller_controls.show()
		2:
			keyboard_controls.hide()
			p1_controller_controls.hide()
			p2_controller_controls.show()
