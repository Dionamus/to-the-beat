extends Node

const full = ["Up", "Down", "Left", "Right", "Light Punch", "Heavy Punch",
	"Light Kick", "Heavy Kick"]
const snake = ["up", "down", "left", "right", "light_punch", "heavy_punch",
	"light_kick", "heavy_kick"]
const pascal = ["Up", "Down", "Left", "Right", "LightPunch", "HeavyPunch",
	"LightKick", "HeavyKick"]


# Returns an action by its full name (e.g. Heavy Punch).
func to_full(action : String) -> String:
	assert(action in snake or action in pascal)
	
	if action in full:
		return action
	elif action in snake:
		return full[snake.find(action)]
	elif action in pascal:
		return full[pascal.find(action)]
	else:
		printerr("'" + action + "' is not a valid input. Returning an empty string")
		return ""


# Returns an action by its name in `snake_case` (e.g. heavy_punch).
func to_snake(action : String) -> String:
	assert(action in full or action in pascal)
	
	if action in snake:
		return action
	elif action in full:
		return snake[full.find(action)]
	elif action in pascal:
		return full[pascal.find(action)]
	else:
		printerr("'" + action + "' is not a valid input. Returning an empty string")
		return ""


# Returns an action by its name in `PascalCase` (e.g. HeavyPunch).
func to_pascal(action : String) -> String:
	assert(action in full or action in snake)
	
	if action in pascal:
		return action
	elif action in full:
		return snake[full.find(action)]
	elif action in snake:
		return full[snake.find(action)]
	else:
		printerr("'" + action + "' is not a valid input. Returning an empty string")
		return ""
