# The game's main menu.
extends Control


func _ready() -> void:
	$Menu/LabelAndButtons/StartGameButton.grab_focus()


# Start the game with one player.
# FIXME: Load the character select screen once it has been implemented.
func _on_StartGameButton_pressed() -> void:
	var error = get_tree().change_scene("res://src/Stage.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the stage.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")


# Start the game with two players.
func _on_VersusButton_pressed() -> void:
	var error = get_tree().change_scene("res://src/DeviceSwap.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the stage.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")


# Show the SettingsMenu.
func _on_SettingsButton_pressed() -> void:
	$Menu.visible = false
	$SettingsMenu.visible = true
	$SettingsMenu/Settings/Panel/ScrollContainer/VBoxContainer/Resolution/ResolutionOptions.grab_focus()


# Hide the main menu and prompt for the quit confirmation.
func _on_QuitToDesktopButton_pressed() -> void:
	$Menu/LabelAndButtons.visible = false
	$Menu/QuitConfirmation.visible = true
	$Menu/QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()


# Hide the quit confirmation and show the main menu.
func _on_QuitConfirmation_did_not_quit() -> void:
	$Menu/QuitConfirmation.visible = false
	$Menu/LabelAndButtons.visible = true
	$Menu/LabelAndButtons/StartGameButton.grab_focus()
