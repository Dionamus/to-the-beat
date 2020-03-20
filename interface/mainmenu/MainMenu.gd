extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelAndButtons/StartGameButton.grab_focus()

# When the "Start Game" button is pressed, change the scene to the main stage.
# In a future update, this will be replaced by the character select
# screen.
func _on_StartGameButton_pressed():
	var error = get_tree().change_scene("res://stages/base/Stage.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the stage.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")

# Show the SettingsMenu when the SettingsButton is pressed.
func _on_SettingsButton_pressed():
	pass

# When the "Quit to Desktop" button is pressed, hide the main menu and 
# show the quit confirmation.
func _on_QuitToDesktopButton_pressed():
	$LabelAndButtons.visible = false
	$QuitConfirmation.visible = true
	$QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()

# When the "No" button is pressed in the quit confirmation, hide the quit
# confirmation and show the main menu.
func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$LabelAndButtons.visible = true
	$LabelAndButtons/StartGameButton.grab_focus()
