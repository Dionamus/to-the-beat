extends HBoxContainer

var bus : int


func setup(b = 0):
	bus = b
	name = AudioServer.get_bus_name(bus) + "Volume"
	$Label.name = AudioServer.get_bus_name(bus)
	$Slider.name = AudioServer.get_bus_name(bus) + "Slider"


func _on_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus, value)
