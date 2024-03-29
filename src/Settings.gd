# A settings configuration backend that initializes the default settings 
# for first-time setup (or if there is a missing config file), and validates
# the config if improperly configured.
extends Node

# The control mode.
#
# `PLAYER_1_EXCLUSIVE`: Player 1 has control of pausing and all menus except
# the character select screen and selecting devices from `DeviceSwap`.
# 
# `TWO_PLAYER_SIMULTANEOUS`: Both players players control pausing and
# navigating the cursor in the menus simultaneously. (This does not apply in
# the character select screen and selecting devices from `DeviceSwap`.)
#
# `TWO_PLAYER_INDIVIDUAL`: Both players get their own cursor for navigating
# menus when not in a game. They must be on the same UI element to confirm the
# selection (this does not happen in the character select screen or
# `DeviceSwap`). Both players have control over pausing, but only the player
# who paused the game has control over the pause menu.).
enum { PLAYER_1_EXCLUSIVE, TWO_PLAYER_SIMULTANEOUS, TWO_PLAYER_INDIVIDUAL }

# The config path.
const CONFIG_SAVE_PATH = "res://config.cfg"

# The config file.
onready var config_file = ConfigFile.new()

# The settings in use.
onready var settings = {
	"video":
	{
		"resolution": "Native Resolution",
		"resolution_box": 0,
		"framerate_limit": Engine.target_fps,
		"framerate_limit_box": 0,
		"vsync": OS.vsync_enabled,
		"fullscreen": OS.window_fullscreen,
		"borderless": OS.window_borderless
	},
	"audio":
	{
		"master": AudioServer.get_bus_volume_db(0),
		"music": AudioServer.get_bus_volume_db(1),
		"sfx": AudioServer.get_bus_volume_db(2),
		"menu_sfx": AudioServer.get_bus_volume_db(3)
	},
	"input":
	{
		"kb_up": InputMap.get_action_list("kb_up"),
		"kb_down": InputMap.get_action_list("kb_down"),
		"kb_left": InputMap.get_action_list("kb_left"),
		"kb_right": InputMap.get_action_list("kb_right"),
		"kb_light_punch": InputMap.get_action_list("kb_light_punch"),
		"kb_heavy_punch": InputMap.get_action_list("kb_heavy_punch"),
		"kb_light_kick": InputMap.get_action_list("kb_light_kick"),
		"kb_heavy_kick": InputMap.get_action_list("kb_heavy_kick"),
		"kb_block": InputMap.get_action_list("kb_block"),
		"p1_up": InputMap.get_action_list("p1_up"),
		"p1_down": InputMap.get_action_list("p1_down"),
		"p1_left": InputMap.get_action_list("p1_left"),
		"p1_right": InputMap.get_action_list("p1_right"),
		"p1_light_punch": InputMap.get_action_list("p1_light_punch"),
		"p1_heavy_punch": InputMap.get_action_list("p1_heavy_punch"),
		"p1_light_kick": InputMap.get_action_list("p1_light_kick"),
		"p1_heavy_kick": InputMap.get_action_list("p1_heavy_kick"),
		"p1_block": InputMap.get_action_list("p1_block"),
		"p2_up": InputMap.get_action_list("p2_up"),
		"p2_down": InputMap.get_action_list("p2_down"),
		"p2_left": InputMap.get_action_list("p2_left"),
		"p2_right": InputMap.get_action_list("p2_right"),
		"p2_light_punch": InputMap.get_action_list("p2_light_punch"),
		"p2_heavy_punch": InputMap.get_action_list("p2_heavy_punch"),
		"p2_light_kick": InputMap.get_action_list("p2_light_kick"),
		"p2_heavy_kick": InputMap.get_action_list("p2_heavy_kick"),
		"p2_block": InputMap.get_action_list("p2_block"),
	},
	"other":
	{
		"control_mode": PLAYER_1_EXCLUSIVE,
	}
}

# The UI controls in use.
onready var ui_controls = {
	"ui_accept": InputMap.get_action_list("ui_accept"),
	"ui_cancel": InputMap.get_action_list("ui_cancel"),
	"ui_up": InputMap.get_action_list("ui_up"),
	"ui_down": InputMap.get_action_list("ui_down"),
	"ui_left": InputMap.get_action_list("ui_left"),
	"ui_right": InputMap.get_action_list("ui_right")
}

# The default settings.
onready var default_settings = {
	"video":
	{
		"resolution": "Native Resolution",
		"resolution_box": 0,
		"framerate_limit": Engine.target_fps,
		"framerate_limit_box": 0,
		"vsync": OS.vsync_enabled,
		"fullscreen": OS.window_fullscreen,
		"borderless": OS.window_borderless
	},
	"audio":
	{
		"master": AudioServer.get_bus_volume_db(0),
		"music": AudioServer.get_bus_volume_db(1),
		"sfx": AudioServer.get_bus_volume_db(2),
		"menu_sfx": AudioServer.get_bus_volume_db(3)
	},
	"input":
	{
		"kb_up": InputMap.get_action_list("kb_up"),
		"kb_down": InputMap.get_action_list("kb_down"),
		"kb_left": InputMap.get_action_list("kb_left"),
		"kb_right": InputMap.get_action_list("kb_right"),
		"kb_light_punch": InputMap.get_action_list("kb_light_punch"),
		"kb_heavy_punch": InputMap.get_action_list("kb_heavy_punch"),
		"kb_light_kick": InputMap.get_action_list("kb_light_kick"),
		"kb_heavy_kick": InputMap.get_action_list("kb_heavy_kick"),
		"kb_block": InputMap.get_action_list("kb_block"),
		"p1_up": InputMap.get_action_list("p1_up"),
		"p1_down": InputMap.get_action_list("p1_down"),
		"p1_left": InputMap.get_action_list("p1_left"),
		"p1_right": InputMap.get_action_list("p1_right"),
		"p1_light_punch": InputMap.get_action_list("p1_light_punch"),
		"p1_heavy_punch": InputMap.get_action_list("p1_heavy_punch"),
		"p1_light_kick": InputMap.get_action_list("p1_light_kick"),
		"p1_heavy_kick": InputMap.get_action_list("p1_heavy_kick"),
		"p1_block": InputMap.get_action_list("p1_block"),
		"p2_up": InputMap.get_action_list("p2_up"),
		"p2_down": InputMap.get_action_list("p2_down"),
		"p2_left": InputMap.get_action_list("p2_left"),
		"p2_right": InputMap.get_action_list("p2_right"),
		"p2_light_punch": InputMap.get_action_list("p2_light_punch"),
		"p2_heavy_punch": InputMap.get_action_list("p2_heavy_punch"),
		"p2_light_kick": InputMap.get_action_list("p2_light_kick"),
		"p2_heavy_kick": InputMap.get_action_list("p2_heavy_kick"),
		"p2_block": InputMap.get_action_list("p2_block"),
	},
	"other":
	{
		"control_mode": PLAYER_1_EXCLUSIVE,
	}
}

# The default UI controls.
onready var _default_ui_controls = {
	"ui_accept": InputMap.get_action_list("ui_accept"),
	"ui_cancel": InputMap.get_action_list("ui_cancel"),
	"ui_up": InputMap.get_action_list("ui_up"),
	"ui_down": InputMap.get_action_list("ui_down"),
	"ui_left": InputMap.get_action_list("ui_left"),
	"ui_right": InputMap.get_action_list("ui_right")
}


func _ready() -> void:
	load_settings()


# Initialize the default settings.
func first_time_setup() -> void:
	for section in default_settings.keys():
		for key in default_settings[section]:
			config_file.set_value(section, key, default_settings[section][key])
	config_file.save(CONFIG_SAVE_PATH)


# Saves the settings.
func save_settings() -> void:
	for section in settings.keys():
		for key in settings[section]:
			config_file.set_value(section, key, settings[section][key])

	config_file.save(CONFIG_SAVE_PATH)


# Loads the settings.
func load_settings() -> void:
	var error = config_file.load(CONFIG_SAVE_PATH)
	match error:
		ERR_FILE_NOT_FOUND:
			first_time_setup()
		OK:
			for section in settings.keys():
				for key in settings[section]:
					# Add new entry if it doesn't exist.
					if ! config_file.has_section_key(section, key):
						config_file.set_value(section, key, default_settings[section][key])
						config_file.save(CONFIG_SAVE_PATH)
					settings[section][key] = config_file.get_value(section, key)

			set_video_setting()
			set_audio_settings()
			set_controls()
			set_control_mode()
		# Any other error.
		_:
			print(
				"An error ocurred, please send the followimg error code to support: " + str(error)
			)


# Sets the video settings and validates the config.
func set_video_setting() -> void:
	# Parse the resolution string.
	var resolution = settings["video"]["resolution"]
	# Native resolution.
	if resolution == "Native Resolution":
		OS.window_size = OS.get_screen_size(0)
		get_tree().get_root().size = OS.get_screen_size(0)
	# Any other resolution (formatted as <width>x<height>).
	else:
		var resolution_regex = RegEx.new()
		resolution_regex.compile("^(\\d+)x(\\d+)$")
		var result = resolution_regex.search(resolution)
		var resolution_width = OS.get_screen_size()
		var resolution_height = OS.get_screen_size()
		if result:
			resolution_width = result.strings[1]
			resolution_height = result.strings[2]
			OS.window_size = Vector2(resolution_width, resolution_height)
			get_tree().get_root().size = Vector2(resolution_width, resolution_height)
		# Revert back to native resolution in case of an improperly
		# formatted resolution string.
		else:
			OS.window_size = OS.get_screen_size(0)
			get_tree().get_root().size = OS.get_screen_size(0)
			resolution = default_settings["video"]["resolution"]
			settings["video"]["resolution"] = resolution
			settings["video"]["resolution_box"] = default_settings["video"]["resolution_box"]
			config_file.set_value("video", "resolution", resolution)
			config_file.set_value(
				"video", "resolution_box", default_settings["video"]["resolution_box"]
			)
			config_file.save(CONFIG_SAVE_PATH)

	# Set up framerate.
	var framerate = settings["video"]["framerate_limit"]
	# Validate the config. Set back to default if not valid.
	if ! (framerate is int) or framerate < 0:
		framerate = default_settings["video"]["framerate"]
		Engine.target_fps = framerate
		settings["video"]["framerate"] = framerate
		settings["video"]["framerate_box"] = default_settings["video"]["framerate_box"]
		config_file.set_value("video", "framerate", framerate)
		config_file.set_value("video", "framerate_box", default_settings["video"]["framerate_box"])
		config_file.save(CONFIG_SAVE_PATH)
	else:
		Engine.target_fps = framerate

	# Set up vsync.
	var vsync = settings["video"]["vsync"]
	# Validate the config. Set back to default if not valid.
	if ! (vsync is bool):
		vsync = default_settings["video"]["vsync"]
		OS.vsync_enabled = vsync
		settings["video"]["vsync"] = vsync
		config_file.set_value("video", "vsync", vsync)
		config_file.save(CONFIG_SAVE_PATH)
	else:
		OS.vsync_enabled = vsync

	# Set up fullscreen.
	var fullscreen = settings["video"]["fullscreen"]
	# Validate the config. Set back to default if not valid.
	if ! (fullscreen is bool):
		fullscreen = default_settings["video"]["fullscreen"]
		OS.window_fullscreen = fullscreen
		settings["video"]["fullscreen"] = fullscreen
		config_file.set_value("video", "fullscreen", fullscreen)
		config_file.save(CONFIG_SAVE_PATH)
	else:
		OS.window_fullscreen = vsync

	# Set up borderless.
	var borderless = settings["video"]["borderless"]
	# Validate the config. Set back to default if not valid.
	if ! (borderless is bool):
		borderless = default_settings["video"]["borderless"]
		OS.window_borderless = borderless
		settings["video"]["borderless"] = borderless
		config_file.set_value("video", "borderless", borderless)
		config_file.save(CONFIG_SAVE_PATH)
	else:
		OS.window_borderless = borderless


# Sets the audio settings and validates the config.
func set_audio_settings() -> void:
	# Set up the master volume.
	var master_volume = settings["audio"]["master"]
	# Validate the config. Set back to default if not valid.
	if ! (master_volume is float):
		master_volume = default_settings["audio"]["master"]
		AudioServer.set_bus_volume_db(0, master_volume)
		settings["audio"]["master"] = master_volume
		config_file.set_value("audio", "master", master_volume)
	else:
		AudioServer.set_bus_volume_db(0, settings["audio"]["master"])

	# Set up the music volume.
	var music_volume = settings["audio"]["music"]
	# Validate the config. Set back to default if not valid.
	if ! (music_volume is float):
		music_volume = default_settings["audio"]["music"]
		AudioServer.set_bus_volume_db(1, music_volume)
		settings["audio"]["music"] = music_volume
		config_file.set_value("audio", "music", music_volume)
	else:
		AudioServer.set_bus_volume_db(1, settings["audio"]["music"])

	# Set up the sound effects volume.
	var sfx_volume = settings["audio"]["sfx"]
	# Validate the config. Set back to default if not valid.
	if ! (sfx_volume is float):
		sfx_volume = default_settings["audio"]["sfx"]
		AudioServer.set_bus_volume_db(2, sfx_volume)
		settings["audio"]["sfx"] = sfx_volume
		config_file.set_value("audio", "sfx", sfx_volume)
	else:
		AudioServer.set_bus_volume_db(2, settings["audio"]["sfx"])

	# Set up the menu sound effects volume.
	var menu_sfx_volume = settings["audio"]["menu_sfx"]
	# Validate the config. Set back to default if not valid.
	if ! (menu_sfx_volume is float):
		menu_sfx_volume = default_settings["audio"]["menu_sfx"]
		AudioServer.set_bus_volume_db(3, menu_sfx_volume)
		settings["audio"]["menu_sfx"] = menu_sfx_volume
		config_file.set_value("audio", "menu_sfx", menu_sfx_volume)
	else:
		AudioServer.set_bus_volume_db(3, settings["audio"]["menu_sfx"])

	config_file.save(CONFIG_SAVE_PATH)


# Sets up the controls and validates the config.
func set_controls() -> void:
	for input in settings["input"].keys():
		# Check the inputs are InputEvents. Otherwise, revert to default.
		for i in range(0, settings["input"][input].size() - 1):
			if ! (settings["input"][input][i] is InputEvent):
				settings["input"][input] = default_settings["input"][input]
				break

		# Check if the keyboard bindings are InputEventKeys and if they have 
		# only one binding. Otherwise, revert to default
		if (
			input.match("kb_*")
			and (
				settings["input"][input].size() != 1
				or (
					! (settings["input"][input][0] is InputEventKey)
					and settings["input"][input].size() == 1
				)
			)
		):
			settings["input"][input] = default_settings["input"][input]

		# Check if Player 1's bindings have only one joystick button and motion,
		# and zero or one keys (in the case of a keyboard player) contained in
		# them. Likewise, check if the device is set to 0. Otherwise, revert to
		# default.
		elif input.match("p1_*"):
			var keys = 0
			var buttons = 0
			var joystick_motions = 0
			for i in range(0, settings["input"][input].size() - 1):
				if settings["input"][input][i] is InputEventKey:
					keys += 1
					# Check if Player 2 doesn't also have keyboard bindings.
					# Revert to default if so.
					for j in range(0, settings["input"]["p2" + input.lstrip("p1")].size() - 1):
						if settings["input"]["p2" + input.lstrip("p1")][j] is InputEventKey:
							settings["input"]["p2" + input.lstrip("p1")] = default_settings["input"][input.lstrip(
								"p1"
							)]
				elif settings["input"][input][i] is InputEventJoypadButton:
					buttons += 1
					if settings["input"][input][i].device != 0:
						settings["input"][input] = default_settings["input"][input]
				elif settings["input"][input][i] is InputEventJoypadMotion:
					joystick_motions += 1
					if settings["input"][input][i].device != 0:
						settings["input"][input] = default_settings["input"][input]

			if buttons != 1 or joystick_motions != 1 or keys != 0 or keys != 1:
				settings["input"][input] = default_settings["input"][input]

		# Check if Player 2's bindings have only one joystick button and motion,
		# and zero or one keys (in the case of a keyboard player) contained in
		# them. Likewise, check if the device is set to 1. Otherwise, revert to
		# default.
		elif input.match("p2_*"):
			var keys = 0
			var buttons = 0
			var joystick_motions = 0
			for i in range(0, settings["input"][input].size() - 1):
				if settings["input"][input][i] is InputEventKey:
					keys += 1
				elif settings["input"][input][i] is InputEventJoypadButton:
					buttons += 1
					if settings["input"][input][i].device != 1:
						settings["input"][input] = default_settings["input"][input]
				elif settings["input"][input][i] is InputEventJoypadMotion:
					joystick_motions += 1
					if settings["input"][input][i].device != 1:
						settings["input"][input] = default_settings["input"][input]

			if buttons != 1 or joystick_motions != 1 or keys != 0 or keys != 1:
				settings["input"][input] = default_settings["input"][input]

		# Apply changes if any.
		ProjectSettings.set_setting("input/" + input, settings["input"][input])
		config_file.set_value("input", input, settings["input"][input])

	config_file.save(CONFIG_SAVE_PATH)


# Sets up the menu control mode and validates the config.
func set_control_mode() -> void:
	# Validate the config.
	if (
		! (settings["other"]["control_mode"] is int)
		or settings["other"]["control_mode"] < PLAYER_1_EXCLUSIVE
		or settings["other"]["control_mode"] > TWO_PLAYER_INDIVIDUAL
	):
		settings["other"]["control_mode"] = PLAYER_1_EXCLUSIVE
		config_file.set_value("other", "control_mode", settings["other"]["control_mode"])
		config_file.save(CONFIG_SAVE_PATH)
		for input in ui_controls.keys():
			ui_controls[input] = _default_ui_controls[input]
			ProjectSettings.set_setting("input/" + input, ui_controls[input])
	# Player 1 controls all menus.
	if settings["other"]["control_mode"] == PLAYER_1_EXCLUSIVE:
		for input in ui_controls.keys():
			for i in range(0, ui_controls[input].size() - 1):
				if (
					ui_controls[input][i] is InputEventJoypadButton
					or ui_controls[input][i] is InputEventJoypadMotion
				):
					ui_controls[input][i].device = 0
					ProjectSettings.set_setting("input/" + input, ui_controls[input])
	# Both players control the cursor in all menus.
	elif settings["other"]["control_mode"] == TWO_PLAYER_SIMULTANEOUS:
		for input in ui_controls.keys():
			for i in range(0, ui_controls[input].size() - 1):
				if (
					ui_controls[input][i] is InputEventJoypadButton
					or ui_controls[input][i] is InputEventJoypadMotion
				):
					ui_controls[input][i].device = -1
					ProjectSettings.set_setting("input/" + input, ui_controls[input])
