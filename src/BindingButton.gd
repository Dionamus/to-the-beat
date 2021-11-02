tool
class_name BindingButton
extends Button

var device : String
var action : String
var action_string : String


func _ready():
	# Check for a valid action string.
	var regex = RegEx.new()
	assert(
		regex.compile("\\A(?:kb|p[12])_(?:up|down|left|right|block|(?:light|heavy)_(?:punch|kick))\\z") == OK
		and regex.search(action_string)
	)
	
	# Ready the bindings, if any.
	if InputMap.get_action_list(action_string).empty() or !InputMap.has_action(action_string):
		text = "No binding."
	else:
		# For the keyboard:
		if device == "kb_" and InputMap.get_action_list(action_string).size() == 1:
			text = InputMap.get_action_list(action_string)[0].as_text()
		
		# For the controllers:
		elif device.match("p?_"):
			for input in InputMap.get_action_list(action_string):
				if input is InputEventJoypadButton:
					text = Input.get_joy_button_string(input.button_index)
					break


# Prepares the binding button to have its binding changed.
func _on_BindingButton_pressed():
	text = "Press a key to rebind..."
	
	# TODO: Disable processing of other nodes when a binding is being changed.
