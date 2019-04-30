extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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

# Quit to the main menu when QuitToMainMenuButton is pressed.
# BUG: Disables MainMenu.tscn's script when pressed.
func _on_QuitToMainMenuButton_pressed():
	get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")

# Hides the pause menu and asks if the user wants to quit to the desktop.
func _on_QuitToDesktopButton_pressed():
	$LabelAndButtons.visible = false
	$QuitConfirmation.visible = true

# If NoButton is pressed, QuitConfirmation disappears and PauseMenu's
# label and buttons reappear.
func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$LabelAndButtons.visible = true
