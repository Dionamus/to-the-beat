extends Node

const full = ["Keyboard", "Player 1", "Player 2"]
const snake = ["kb_", "p1_", "p2_"]
const pascal = ["KB", "P1", "P2"]

# Returns a device by its full name (e.g. Heavy Punch).
func to_full(device : String) -> String:
	assert(device in snake or device in pascal)
	
	if device in full:
		return device
	elif device in snake:
		return full[snake.find(device)]
	elif device in pascal:
		return full[pascal.find(device)]
	else:
		printerr("'" + device + "is not a valid input. Returning an empty string")
		return ""


# Returns a device by its name in `snake_case` (e.g. heavy_punch).
func to_snake(device : String) -> String:
	assert(device in full or device in pascal)
	
	if device in snake:
		return device
	elif device in full:
		return snake[full.find(device)]
	elif device in pascal:
		return full[pascal.find(device)]
	else:
		printerr("'" + device + "is not a valid input. Returning an empty string")
		return ""


# Returns a device by its name in `PascalCase` (e.g. HeavyPunch).
func to_pascal(device : String) -> String:
	assert(device in full or device in snake)
	
	if device in pascal:
		return device
	elif device in full:
		return snake[full.find(device)]
	elif device in snake:
		return full[snake.find(device)]
	else:
		printerr("'" + device + "is not a valid input. Returning an empty string")
		return ""
