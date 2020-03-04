extends Node

const CONFIG_SAVE_PATH = "res://config.cfg"
const DEFAULT_CONFIG_SAVE_PATH = "res://default.cfg"

var config_file = ConfigFile.new()
var default_config_file = ConfigFile.new()
var default_settings = {
	"video": {
		"resolution": "Native Resolution",
		"resolution_box": 0,
		"framerate_limit": Engine.target_fps,
		"framerate_limit_box": 0,
		"vsync": OS.vsync_enabled,
		"fullscreen": OS.window_fullscreen,
		"borderless": OS.window_borderless
	},
	"audio": {
		"master": AudioServer.get_bus_volume_db(0),
		"music": AudioServer.get_bus_volume_db(1),
		"sfx": AudioServer.get_bus_volume_db(2),
		"menu_sfx": AudioServer.get_bus_volume_db(3)
	},
	"input": {
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
	"other": {
		"control_mode": "Player 1 Exclusive Control"
	}
}

var settings = {
	"video": {
		"resolution": "Native Resolution",
		"resolution_box": 0,
		"framerate_limit": Engine.target_fps,
		"framerate_limit_box": 0,
		"vsync": OS.vsync_enabled,
		"fullscreen": OS.window_fullscreen,
		"borderless": OS.window_borderless
	},
	"audio": {
		"master": AudioServer.get_bus_volume_db(0),
		"music": AudioServer.get_bus_volume_db(1),
		"sfx": AudioServer.get_bus_volume_db(2),
		"menu_sfx": AudioServer.get_bus_volume_db(3)
	},
	"input": {
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
	"other": {
		"control_mode": "Player 1 Exclusive Control"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()

# Initialize the default settings.
func first_time_setup():
	for section in default_settings.keys():
		for key in default_settings[section]:
			config_file.set_value(section, key, default_settings[section][key])
			default_config_file.set_value(section, key, default_settings[section][key])
	
	config_file.save(CONFIG_SAVE_PATH)
	default_config_file.save(DEFAULT_CONFIG_SAVE_PATH)
	
func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config_file.set_value(section, key, settings[section][key])
	
	config_file.save(CONFIG_SAVE_PATH)

func load_settings():
	var error = config_file.load(CONFIG_SAVE_PATH)
	match error:
		ERR_FILE_NOT_FOUND:
			first_time_setup()
		OK:
			for section in settings.keys():
				for key in settings[section]:
					if !config_file.has_section_key(section, key):
						config_file.set_value(section, key, default_settings[section][key])
					settings[section][key] = config_file.get_value(section, key)
			
			set_video_setting()
			set_audio_settings()
			set_controls()
		# Any other error
		_:
			print("An error ocurred, please send the followimg error code to support: " + str(error))

func set_video_setting():
	# Parse the resolution string
	var resolution = settings["video"]["resolution"]
	# Native resolution
	if resolution == "Native Resolution":
		OS.window_size = OS.get_screen_size(0)
		get_tree().get_root().size = OS.get_screen_size(0)
	# Any other resolution (formatted as <width>x<height>)
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
			resolution = "Native Resolution"
			settings["video"]["resolution"] = resolution
			settings["video"]["resolution_box"] = 0
	
	# Set up everything else.
	Engine.target_fps = settings["video"]["framerate_limit"]
	OS.vsync_enabled = settings["video"]["vsync"]
	OS.window_fullscreen = settings["video"]["fullscreen"]
	OS.window_borderless = settings["video"]["borderless"]

func set_audio_settings():
	AudioServer.set_bus_volume_db(0, settings["audio"]["master"])
	AudioServer.set_bus_volume_db(1, settings["audio"]["music"])
	AudioServer.set_bus_volume_db(2, settings["audio"]["sfx"])
	AudioServer.set_bus_volume_db(3, settings["audio"]["menu_sfx"])

func set_controls():
	for input in settings["input"].keys():
		ProjectSettings.set_setting("input/" + input, settings["input"][input])
