extends CenterContainer

func _on_QuitToDesktop_pressed():
	$WinLabelAndButtons.visible = false
	$QuitConfirmation.visible = true
	$QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()

func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$WinLabelAndButtons.visible = true
	$LabelAndButtons/StartGameButton.grab_focus()

func _on_RematchButton_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
