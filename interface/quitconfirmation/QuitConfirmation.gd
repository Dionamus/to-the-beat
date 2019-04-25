extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Quit the game when YesButton is pressed.
func _on_YesButton_pressed():
	get_tree().quit()
	pass # Replace with function body.

# Get rid of the quit dialog when NoButton is pressed.
func _on_NoButton_pressed():
	free()
