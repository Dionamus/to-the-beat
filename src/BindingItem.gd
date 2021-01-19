class_name BindingItem
extends HBoxContainer


func setup(device = "Keyboard", action = "Up"):
	name = Actions.to_pascal(action)
	$BindingLabel.text = action
	$BindingButton.device = Devices.to_snake(device)
	$BindingButton.action = Actions.to_snake(action)
	$BindingButton.action_string = Devices.to_snake(device) + \
		Actions.to_snake(action)
