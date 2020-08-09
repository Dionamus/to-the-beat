extends Control


# Unpause the game when either player presses the pause button.
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("p1_pause") or Input.is_action_just_pressed("p2_pause"):
		if visible:
			hide()
			release_focus()
			get_tree().paused = false
		else:
			show()
			$Menu/LabelAndButtons/ResumeGameButton.grab_focus()
			get_tree().paused = true


# Hide the pause menu and unpause the game when ResumeGameButton is pressed.
func _on_ResumeGameButton_pressed() -> void:
	hide()
	get_tree().paused = false


# Currently not implemented.
func _on_SettingsButton_pressed() -> void:
	$Menu.visible = false
	$SettingsMenu.visible = true
	$SettingsMenu/Settings/Panel/ScrollContainer/VBoxContainer/Resolution/ResolutionOptions.grab_focus()


# Currently not implemented.
func _on_QuitToCharacterSelectButton_pressed() -> void:
	pass  # Replace with function body.


# Hides the pause menu and asks if the user wants to quit to the desktop.
func _on_QuitToDesktopButton_pressed() -> void:
	$Menu/LabelAndButtons.visible = false
	$Menu/QuitConfirmation.visible = true
	$Menu/QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()


# If NoButton is pressed, QuitConfirmation disappears and PauseMenu's
# label and buttons reappear.
func _on_QuitConfirmation_did_not_quit() -> void:
	$Menu/QuitConfirmation.visible = false
	$Menu/LabelAndButtons.visible = true
	$Menu/LabelAndButtons/ResumeGameButton.grab_focus()
