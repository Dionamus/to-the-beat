extends CenterContainer

# Unpause the game when either player presses the pause button.
func _unhandled_input(_event):
	if Input.is_action_just_pressed("p1_pause")\
	or Input.is_action_just_pressed("p2_pause"):
		if visible:
			hide()
			release_focus()
			get_tree().paused = false
		else:
			show()
			$LabelAndButtons/ResumeGameButton.grab_focus()
			get_tree().paused = true

# Hide the pause menu and unpause the game when ResumeGameButton is pressed.
func _on_ResumeGameButton_pressed():
	hide()
	get_tree().paused = false

# Currently not implemented.
func _on_OptionsButton_pressed():
	pass # Replace with function body.

# Currently not implemented.
func _on_QuitToCharacterSelectButton_pressed():
	pass # Replace with function body.

# Hides the pause menu and asks if the user wants to quit to the desktop.
func _on_QuitToDesktopButton_pressed():
	$LabelAndButtons.visible = false
	$QuitConfirmation.visible = true
	$QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()

# If NoButton is pressed, QuitConfirmation disappears and PauseMenu's
# label and buttons reappear.
func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$LabelAndButtons.visible = true
	$LabelAndButtons/ResumeGameButton.grab_focus()
