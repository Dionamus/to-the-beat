extends Node

# Tempo of the stage in beats per minute. ONLY USE FOR DEBUGGING.
# This is meant to be passed from the music select screen (not implmented yet).
# The default value is 120 BPM because that's the speed the animations are
# tied to.
export (int) var bpm = 120

# Note: Do not assign the position markers to other variables. It will throw
# errors in the debugger. -Brandon Hawkins

# Preload images for the win counters.
onready var no_wins = preload("res://interface/hud/no_wins.png")
onready var p1_one_win = preload("res://interface/hud/p1_one_win.png")
onready var p2_one_win = preload("res://interface/hud/p2_one_win.png")
onready var two_wins = preload("res://interface/hud/two_wins.png")

# HUD variables
onready var p1_HP_bar = $CanvasLayer/HUD/HBoxContainer/Player1Container/Player1HP
onready var p1_name = $CanvasLayer/HUD/HBoxContainer/Player1Container/P1NameAndWins/Player1Name
onready var p1_wins = $CanvasLayer/HUD/HBoxContainer/Player1Container/P1NameAndWins/Player1Wins
onready var p2_HP_bar = $CanvasLayer/HUD/HBoxContainer/Player2Container/Player2HP
onready var p2_name = $CanvasLayer/HUD/HBoxContainer/Player2Container/P2NameAndWins/Player2Name
onready var p2_wins = $CanvasLayer/HUD/HBoxContainer/Player2Container/P2NameAndWins/Player2Wins
onready var timer_label = $CanvasLayer/HUD/HBoxContainer/GameTimerContainer/GameTimerLabel
onready var win_round_label = $CanvasLayer/WinMenu/WinLabelAndButtons/WinLabel

# Used for controling the flow of the game.
onready var is_game_over = false
onready var is_input_allowed = false

onready var tween = $Tween

# onready var debug_timer = 0

# The start frame for the tempo timing.
onready var start_frame = 21

# The end frame for the tempo timing.
onready var end_frame = 8

# Used for synchronizing the animations of the player characters.
onready var tempo_control = $ControlCharacter/AnimatedSprite

# Player variables
onready var player1 = $FollowCamera/Player1
onready var player1_anim = $FollowCamera/Player1/AnimatedSprite

onready var player2 = $FollowCamera/Player2
onready var player2_anim = $FollowCamera/Player2/AnimatedSprite

func _ready():
	# Set up the HUD.
	# Set the players' HP bar to represent their max HP.
	p1_HP_bar.value = player1.max_hitpoints
	p2_HP_bar.value = player2.max_hitpoints
	
	# Force the timer_label to 99 seconds. This is to prevent a bug where the
	# timer would be set to 0 at the beginning of the game if we were to use
	# the timer's time_left variable.
	timer_label.text = "99"
	
	# Sets up the ControlCharacter for tempo timing
	$ControlCharacter.set_speed_of_animation_by_BPM(bpm)
	tempo_control.animation = "idle"
	tempo_control.playing = false
	tempo_control.frame = 0
	
	# Sets up Player1
	player1.set_speed_of_animation_by_BPM(bpm)
	player1.hide()
	player1.grid_number = 0
	set_position(player1, player1.grid_number)
	player1_anim.animation = "idle"
	player1_anim.playing = false
	player1_anim.frame = 0
	player1_anim.flip_h = false
	player1.player_number = 1
	
	# Sets up Player2
	player2.set_speed_of_animation_by_BPM(bpm)
	player2.hide()
	player2.grid_number = 8
	set_position(player2, player2.grid_number)
	player2_anim.animation = "idle"
	player2_anim.playing = false
	player2_anim.frame = 0
	player2_anim.flip_h = true
	player2.player_number = 2
	
	# Hide the debug information at the beginning of the game.
	$CanvasLayer/Debug.hide()
	
	# Starts the game.
	$StartTimer.start()

func _unhandled_input(event):
	# Allow the input if the game is not over and input is allowed.
	if !is_game_over and is_input_allowed:
		# Flip the player position  when they are on the opposite sides of each 
		# other. They currently cant't do this as they cannot jump over each 
		# other.
		if player1.position.x > player2.position.x:
			player1_anim.flip_h = true
			player2_anim.flip_h = false
		else:
			player1_anim.flip_h = false
			player2_anim.flip_h = true
		
		# Tempo controls
		# FIXME: Flesh out the controls more.
		
		# Format: The game submits input between frames 21 and 29, between
		# frames 0 and 8 (frame 0 is when the animation "bottoms out" on the
		# beat), and if the player is able to attack. If the player is moving,
		# it checks if the player is on the left- or right-most grid position
		# before moving. If the player is attacking, it checks whether they are
		# next to their opponent before delivering damage. If either of them
		# are blocking, the attacker's attacks won't go through. If either of
		# them hit the pause button, the game will pause and bring up the pause
		# menu. The opposite will happen when they hit the pause button again.
		
		# Player 1 controls
		if Input.is_action_just_pressed("p1_left"):
			if player1.grid_number != 0\
			and player1.grid_number != player2.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player1.is_allowed_input:
					player1.grid_number -= 1
					set_position(player1, player1.grid_number)
					player1.is_allowed_input = false
		if Input.is_action_just_pressed("p1_right"):
			if player1.grid_number != 8\
			and player1.grid_number != player2.grid_number - 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player1.is_allowed_input:
					player1.grid_number += 1
					set_position(player1, player1.grid_number)
					player1.is_allowed_input = false
		if Input.is_action_just_pressed("p1_front_punch"):
			if player1.grid_number == player2.grid_number - 1\
			or $FollowCamera/Player1.grid_number == player2.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player1.is_allowed_input:
					if not player2.is_blocking:
						player2._on_Character_is_hit(10)
						player1.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p1_back_punch"):
			if player1.grid_number == player2.grid_number - 1\
			or player1.grid_number == player2.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player1.is_allowed_input:
					if not player2.is_blocking:
						player2._on_Character_is_hit(20)
						player1.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p1_front_kick"):
			if player1.grid_number == player2.grid_number - 1\
			or player1.grid_number == player2.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player1.is_allowed_input:
					if not player2.is_blocking:
						player2._on_Character_is_hit(10)
						player1.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p1_rear_kick"):
			if player1.grid_number == player2.grid_number - 1\
			or player1.grid_number == player2.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player1.is_allowed_input:
					if not player2.is_blocking:
						player2._on_Character_is_hit(10)
						player1.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_pressed("p1_block"):
			player1.is_blocking = true
		if Input.is_action_just_released("p1_block"):
			player1.is_blocking = false
		if Input.is_action_just_pressed("p1_pause"):
			if $CanvasLayer/PauseMenu.visible:
				$CanvasLayer/PauseMenu.hide()
				$CanvasLayer/PauseMenu.release_focus()
				get_tree().paused = false
			else:
				get_tree().paused = true
				$CanvasLayer/PauseMenu.show()
				$CanvasLayer/PauseMenu/LabelAndButtons/QuitToMainMenuButton.grab_focus()
		
		# Player 2 controls
		if Input.is_action_just_pressed("p2_left"):
			if player2.grid_number != 0\
			and player2.grid_number != player1.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player2.is_allowed_input:
					player2.grid_number -= 1
					set_position(player2, player2.grid_number)
					player2.is_allowed_input = false
		if Input.is_action_just_pressed("p2_right"):
			if player2.grid_number != 8\
			and player2.grid_number != player1.grid_number - 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player2.is_allowed_input:
					player2.grid_number += 1
					set_position(player2, player2.grid_number)
					player2.is_allowed_input = false
		if Input.is_action_just_pressed("p2_front_punch"):
			if player2.grid_number == player1.grid_number - 1\
			or player2.grid_number == player1.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player2.is_allowed_input:
					if not player1.is_blocking:
						player1._on_Character_is_hit(10)
						player2.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p2_back_punch"):
			if player2.grid_number == player1.grid_number - 1\
			or player2.grid_number == player1.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player2.is_allowed_input:
					if not player1.is_blocking:
						player1._on_Character_is_hit(20)
						player2.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p2_front_kick"):
			if player2.grid_number == player1.grid_number - 1\
			or player2.grid_number == player1.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player2.is_allowed_input:
					if not player1.is_blocking:
						player1._on_Character_is_hit(10)
						player2.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p2_rear_kick"):
			if player2.grid_number == player1.grid_number - 1\
			or player2.grid_number == player1.grid_number + 1:
				if (tempo_control.frame <= end_frame\
				or tempo_control.frame >= start_frame)\
				and player2.is_allowed_input:
					if not player1.is_blocking:
						player1._on_Character_is_hit(20)
						player2.is_allowed_input = false
			else:
				# This will change in a future update
				return
		if Input.is_action_pressed("p2_block"):
			player2.is_blocking = true
		if Input.is_action_just_released("p2_block"):
			player2.is_blocking = false
		if Input.is_action_just_pressed("p2_pause"):
			if $CanvasLayer/PauseMenu.visible:
				$CanvasLayer/PauseMenu.hide()
				$CanvasLayer/PauseMenu.release_focus()
				get_tree().paused = false
			else:
				get_tree().paused = true
				$CanvasLayer/PauseMenu.show()
				$CanvasLayer/PauseMenu/LabelAndButtons/QuitToMainMenuButton.grab_focus()

func _process(delta):
	# Make sure that the frame number for the players' sprites
	# are the same as the control sprite.
	player1_anim.frame = tempo_control.frame
	player2_anim.frame = tempo_control.frame
	
	if tempo_control.frame == end_frame:
		player1.is_allowed_input = true
		player2.is_allowed_input = true
	
	# Show the time remaining for the first round to start at the beginning of
	# a game.
	if not $StartTimer.is_stopped():
		$CanvasLayer/StartTimerLabel.text = "Round begins in:\n"\
		+ str(int($StartTimer.time_left))
	
	# Show the time remaining for the next round to start after a round ends.
	if not $PostWinTimer.is_stopped():
		$CanvasLayer/StartTimerLabel.text = "Round begins in:\n"\
		+ str(int($PostWinTimer.time_left))
	
	# This if statement is to prevent a bug where the timer would be set to 0
	# at the beginning of the game if we were to use the timer's time_left
	# variable.
	if not $GameTimer.is_stopped():
		timer_label.text = str(int($GameTimer.time_left))
	
	# Update the players' HP bars with their current hitpoints.
	p1_HP_bar.value = player1.hitpoints
	p2_HP_bar.value = player2.hitpoints
	
	# Update the debug information's frame rate, animation frame rate, and tempo.
	$CanvasLayer/Debug/FrameRate.text = "Frame Rate: "\
		+ str(Engine.get_frames_per_second()) + " FPS"
	$CanvasLayer/Debug/AnimationFrameRate.text = "Animation Frame Rate: "\
		+ str(tempo_control.frames.get_animation_speed("idle")) + " FPS"
	$CanvasLayer/Debug/Tempo.text = "Tempo " + str(bpm) + " BPM"

# Sets the position of the player characters.
# main_player is the player that is being controlled, the grid number is the 
# grid_number that the position is being set to.
func set_position(main_player, grid_number):
	tween.interpolate_property(main_player, "position", main_player.position,
			get_node("Position" + str(grid_number)).position, .2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


# When the StartTimer times out, show the Character classes, play their sprites,
# allow input, play the music, then start the game timer.
func _on_StartTimer_timeout():
	player1.show()
	player1_anim.playing = true
	
	player2.show()
	player2_anim.playing = true
	
	tempo_control.playing = true
	
	is_input_allowed = true
	
	$CanvasLayer/StartTimerLabel.hide()
	
	$AudioStreamPlayer.playing = true
	
	$GameTimer.start()

# If the game ends before either player defeats the other, disable input, set
# is_game_over to true, and if either player has more HP than the other, show
# the win menu with the label showing that the winning player won the game.
# If they tie, show that they tie.
func _on_GameTimer_timeout():
	is_game_over = true
	is_input_allowed = false
	if player1.hitpoints > player2.hitpoints:
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinLabel.text = "Player 1 wins the game!"
	elif player2.hitpoints > player1.hitpoints:
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinLabel.text = "Player 2 wins the game!"
	else:
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinLabel.text = "Tie! No one wins!"

# When player 1 wins a round, increment their wins. If they have 1 win,
# show that they have won a round, pause the game timer and input, reset their
# HP, and begin a countdown for the next round. If they have two wins, show
# that they have won two rounds, set is_game_over to true and is_input_allowed
# to false, stop the game timer and show the win menu with the lable showing
# that player 1 has won the round.
func _on_Player1_win_round():
	player1.wins += 1
	if player1.wins == 1:
		p1_wins.texture = p1_one_win
		$GameTimer.paused = true
		is_input_allowed = false
		$CanvasLayer/StartTimerLabel.show()
		player1.reset_hp()
		player2.reset_hp()
		$PostWinTimer.start()
	elif player1.wins == 2:
		p1_wins.texture = two_wins
		is_game_over = true
		is_input_allowed = false
		$GameTimer.stop()
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinMenu/WinLabelAndButtons/QuitToMainMenuButton.grab_focus()
		win_round_label.text = "Player 1 wins!"

# When player 2 wins a round, increment their wins. If they have 1 win,
# show that they have won a round, pause the game timer and input, reset their
# HP, and begin a countdown for the next round. If they have two wins, show
# that they have won two rounds, set is_game_over to true and is_input_allowed
# to false, stop the game timer and show the win menu with the lable showing
# that player 2 has won the round.
func _on_Player2_win_round():
	player2.wins += 1
	if player2.wins == 1:
		print("Player 2 has one win.")
		p2_wins.texture = p2_one_win
		$GameTimer.paused = true
		is_input_allowed = false
		$CanvasLayer/StartTimerLabel.show()
		player1.reset_hp()
		player2.reset_hp()
		$PostWinTimer.start()
	elif player2.wins == 2:
		print("Player 2 has two wins.")
		p2_wins.texture = two_wins
		is_game_over = true
		is_input_allowed = false
		$GameTimer.stop()
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinMenu/WinLabelAndButtons/QuitToMainMenuButton.grab_focus()
		win_round_label.text = "Player 2 wins!"

# When player 1 loses a round, increment their losses and call the method
# to have player 2 win the round.
func _on_Player1_lose_round():
	player1.losses += 1
	_on_Player2_win_round()

# When player 2 loses a round, increment their losses and call the method
# to have player 1 win the round.
func _on_Player2_lose_round():
	player2.losses += 1
	_on_Player1_win_round()

# When the post-win timer times out, if the neither of the players haven't won a
# game yet, unpause the game timer, hide the start timer label (which is used
# for showing the time remaining before a new round starts with the post-win
# timer), enable input, and reset the players' hitpoints (.
func _on_PostWinTimer_timeout():
	if player1.wins != 2 or player2.wins != 2:
		$GameTimer.paused = false
		$CanvasLayer/StartTimerLabel.hide()
		is_input_allowed = true
		player1.reset_hp()
		player2.reset_hp()
