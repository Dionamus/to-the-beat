extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/LabelAndButtons/StartGameButton.grab_focus()

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
	$Menu.visible = false
	$SettingsMenu.visible = true
	$SettingsMenu/Settings/Panel/ScrollContainer/VBoxContainer/Resolution/ResolutionOptions.grab_focus()

# When the "Quit to Desktop" button is pressed, hide the main menu and 
# show the quit confirmation.
func _on_QuitToDesktopButton_pressed():
	$Menu/LabelAndButtons.visible = false
	$Menu/QuitConfirmation.visible = true
	$Menu/QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()

# When the "No" button is pressed in the quit confirmation, hide the quit
# confirmation and show the main menu.
func _on_QuitConfirmation_no_quit():
	$Menu/QuitConfirmation.visible = false
	$Menu/LabelAndButtons.visible = true
	$Menu/LabelAndButtons/StartGameButton.grab_focus()
