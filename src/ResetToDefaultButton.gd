tool
class_name ResetToDefaultButton
extends Button

export (String, "All", "Keyboard", "Player 1", "Player 2") var device : String


func _ready():
	assert(device in Devices.full or device == "All")
	
	if device == "All":
		text = "Reset all bindings to default."
	else:
		text = "Reset to default."


func setup(d : String):
	device = d


func _on_ResetToDefaultButton_pressed():
	pass # Replace with function body.
