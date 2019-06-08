extends CenterContainer

func _on_QuitToDesktop_pressed():
	$WinLabelAndButtons.visible = false
	$QuitConfirmation.visible = true

func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$WinLabelAndButtons.visible = true
