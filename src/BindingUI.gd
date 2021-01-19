class_name BindingUI
extends VBoxContainer

func _ready():
	for device in Devices.full:
		var binding_group = preload("res://src/BindingGroup.tscn").instance()
		binding_group.setup(device)
		add_child(binding_group)
