# A menu that appears when a game ends.
extends CenterContainer


# Readys the quit confirmation.
func _on_QuitToDesktop_pressed() -> void:
	$WinLabelAndButtons.visible = false
	$QuitConfirmation.visible = true
	$QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()


# Goes back to the win menu if the user doesn't want to quit the game.
func _on_QuitConfirmation_did_not_quit() -> void:
	$QuitConfirmation.visible = false
	$WinLabelAndButtons.visible = true
	$LabelAndButtons/StartGameButton.grab_focus()


# Starts a new match.
func _on_RematchButton_pressed() -> void:
	var error = get_tree().reload_current_scene()
	match error:
		ERR_CANT_OPEN:
			printerr("For some stupid reason this scene cannot open itself.")
		ERR_CANT_CREATE:
			printerr("For some stupid reason this scene cannot instatiate itself.")
