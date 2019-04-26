extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_ResumeGameButton_pressed():
	hide()
	get_tree().paused = false

func _on_OptionsButton_pressed():
	pass # Replace with function body.

func _on_QuitToCharacterSelectButton_pressed():
	pass # Replace with function body.

func _on_QuitToMainMenuButton_pressed():
	get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")

func _on_QuitToDesktopButton_pressed():
	$LabelAndButtons.visible = false
	$QuitConfirmation.visible = true

func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$LabelAndButtons.visible = true
