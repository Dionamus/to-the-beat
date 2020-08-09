extends CenterContainer


# Readys the quit confirmation.
func _on_QuitToDesktop_pressed():
	$WinLabelAndButtons.visible = false
	$QuitConfirmation.visible = true
	$QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()


# Goes back to the win menu if the user doesn't want to quit the game.
func _on_QuitConfirmation_did_not_quit():
	$QuitConfirmation.visible = false
	$WinLabelAndButtons.visible = true
	$LabelAndButtons/StartGameButton.grab_focus()


# Starts a new match.
func _on_RematchButton_pressed():
	get_tree().reload_current_scene()
	pass  # Replace with function body.
