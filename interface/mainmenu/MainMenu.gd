extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelAndButtons/StartGameButton.grab_focus()
	
	# Now, you must be asking yourself: "Why is the code below even here? It's
	# not even doing anything meaningful for the user!" Well, right now, it's
	# to help me figure out how I (Brandon/Dionamus) should implement changing
	# the player input bindings in the settings menu and changing which player
	# is using keyboard controls.
	# 
	# And to answer your next question: "Why is this code having to do with
	# changing input bindings in the main menu's script?" Well, that is because
	# the scene that this script is tied to is the first to appear when I open
	# this project. Long story short: I'm too lazy to dig through the file tree
	# to put this testing code in the settings menu script, where it should
	# belong.
	#
	# Thankfully, the code you see here will be gone one day.
	print(InputMap.get_action_list("kb_up")[0].as_text())
	print(InputMap.get_action_list("p1_up")[0].get_class())
	print(InputMap.get_action_list("p1_up").size())
	var i = 0
	while i <= InputMap.get_action_list("p1_up").size() - 1:
		if InputMap.get_action_list("p1_up")[i].get_class() == InputMap.get_action_list("kb_up")[0].get_class()\
		and InputMap.get_action_list("p1_up")[i].scancode == InputMap.get_action_list("kb_up")[0].scancode:
			print("Objects match.")
			break
	var j = 0
	while j <= InputMap.get_action_list("p1_up").size() - 1:
		if InputMap.get_action_list("p1_up")[j].get_class() == "InputEventKey":
			print(InputMap.get_action_list("p1_up")[j])
			print(InputMap.get_action_list("p1_up").size())
			break

# When the "Start Game" button is pressed, change the scene to the main stage.
# In a future update, this will be replaced by the character select
# screen.
func _on_StartGameButton_pressed():
	var error = get_tree().change_scene("res://stages/base/Stage.tscn")
	match error:
		ERR_CANT_OPEN:
			printerr("Cannot open the scene to the stage.")
		ERR_CANT_CREATE:
			printerr("Cannot instantiate the stage.")

# Show the SettingsMenu when the SettingsButton is pressed.
func _on_SettingsButton_pressed():
	pass

# When the "Quit to Desktop" button is pressed, hide the main menu and 
# show the quit confirmation.
func _on_QuitToDesktopButton_pressed():
	$LabelAndButtons.visible = false
	$QuitConfirmation.visible = true
	$QuitConfirmation/LabelAndButtons/YesNoButtonContainer/YesButton.grab_focus()

# When the "No" button is pressed in the quit confirmation, hide the quit
# confirmation and show the main menu.
func _on_QuitConfirmation_no_quit():
	$QuitConfirmation.visible = false
	$LabelAndButtons.visible = true
	$LabelAndButtons/StartGameButton.grab_focus()
