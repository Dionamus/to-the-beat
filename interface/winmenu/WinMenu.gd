extends CenterContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://interface/mainmenu/MainMenu.tscn")

func _on_QuitToDesktop_pressed():
	$WinLabelAndButtons.visible = false
	$QuitConfirmation.visible = true

func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$WinLabelAndButtons.visible = true
