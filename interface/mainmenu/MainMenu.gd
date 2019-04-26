extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartGameButton_pressed():
#	breakpoint
	get_tree().change_scene("res://stages/base/Stage.tscn")

func _on_OptionsButton_pressed():
	pass # Replace with function body.

func _on_QuitToDesktopButton_pressed():
	$LabelAndButtons.visible = false
	$QuitConfirmation.visible = true

func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$LabelAndButtons.visible = true
