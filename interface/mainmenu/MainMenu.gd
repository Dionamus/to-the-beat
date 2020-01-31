extends CenterContainer

onready var array = [1, "two", 3]

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelAndButtons/StartGameButton.grab_focus()
	print(InputMap.get_action_list("p1_up")[0].as_text())
	print(array)
	print(InputMap.get_action_list("kb_up")[0].as_text())
	print(InputMap.get_action_list("p1_up").find(InputMap.get_action_list("kb_up")[0]))
#	print(InputMap.get_actions())

# When the "Start Game" button is pressed, change the scene to the main stage.
# In a future update, this will be replaced by the character select
# screen.
func _on_StartGameButton_pressed() -> void:
	get_tree().change_scene("res://stages/base/Stage.tscn")

# Show the SettingsMenu when the SettingsButton is pressed.
func _on_SettingsButton_pressed():
	pass

# When the "Quit to Desktop" button is pressed, hide the main menu and 
# show the quit confirmation.
func _on_QuitToDesktopButton_pressed() -> void:
	$LabelAndButtons.visible = false
	$QuitConfirmation.visible = true
	$QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()

# When the "No" button is pressed in the quit confirmation, hide the quit
# confirmation and show the main menu.
func _on_QuitConfirmation_no_quit() -> void:
	$QuitConfirmation.visible = false
	$LabelAndButtons.visible = true
	$LabelAndButtons/StartGameButton.grab_focus()
