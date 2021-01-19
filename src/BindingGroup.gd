class_name BindingGroup
extends VBoxContainer


func setup(device = "Keyboard"):
	assert(device in Devices.full)
	
	name = device
	$GroupLabel.text = device
	for action in Actions.full:
		var binding_item = preload("res://src/BindingItem.tscn").instance()
		binding_item.setup(device, action)
		add_child(binding_item)
	
	var reset_binding_button = preload("res://src/ResetToDefaultButton.tscn").instance()
	reset_binding_button.setup(device)
	add_child(reset_binding_button)
