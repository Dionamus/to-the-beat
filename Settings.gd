extends Node

const CONFIG_SAVE_PATH = "user://config.cfg"

var _config_file = ConfigFile.new()
var initial_config_settings = {
	"video": {
		"resolution": "Native Resolution",
		"framerate_limit": Engine.target_fps,
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
	"keyboard_controls": {
		"up": InputMap.get_action_list("kb_up"),
		"down": InputMap.get_action_list("kb_down"),
		"left": InputMap.get_action_list("kb_left"),
		"right": InputMap.get_action_list("kb_right"),
		"light_punch": InputMap.get_action_list("kb_light_punch"),
		"heavy_punch": InputMap.get_action_list("kb_heavy_punch"),
		"light_kick": InputMap.get_action_list("kb_light_kick"),
		"heavy_kick": InputMap.get_action_list("kb_heavy_kick"),
		"block": InputMap.get_action_list("kb_block"),
	},
	"p1_controller_controls": {
		"up": InputMap.get_action_list("p1_up"),
		"down": InputMap.get_action_list("p1_down"),
		"left": InputMap.get_action_list("p1_left"),
		"right": InputMap.get_action_list("p1_right"),
		"light_punch": InputMap.get_action_list("p1_light_punch"),
		"heavy_punch": InputMap.get_action_list("p1_heavy_punch"),
		"light_kick": InputMap.get_action_list("p1_light_kick"),
		"heavy_kick": InputMap.get_action_list("p1_heavy_kick"),
		"block": InputMap.get_action_list("p1_block"),
	},
	"p2_controller_controls": {
		"up": InputMap.get_action_list("p2_up"),
		"down": InputMap.get_action_list("p2_down"),
		"left": InputMap.get_action_list("p2_left"),
		"right": InputMap.get_action_list("p2_right"),
		"light_punch": InputMap.get_action_list("p2_light_punch"),
		"heavy_punch": InputMap.get_action_list("p2_heavy_punch"),
		"light_kick": InputMap.get_action_list("p2_light_kick"),
		"heavy_kick": InputMap.get_action_list("p2_heavy_kick"),
		"block": InputMap.get_action_list("p2_block"),
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

