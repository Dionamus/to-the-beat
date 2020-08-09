extends Node

# The start frame for the tempo timing.
const START_FRAME := 21

# The end frame for the tempo timing.
const END_FRAME := 8

# Tempo of the stage in beats per minute. ONLY USE FOR DEBUGGING.
# This is meant to be passed from the music select screen (not implmented yet).
# The default value is 120 BPM because that's the speed the animations are
# tied to.
export (int) var bpm := 120

# Note: Do not assign the position markers to other variables. It will throw
# errors in the debugger. -Brandon Hawkins

# Preload images for the win counters.
onready var _no_wins := preload("res://assets/interface/no_wins.png")
onready var _one_win := preload("res://assets/interface/one_win.png")
onready var _two_wins := preload("res://assets/interface/two_wins.png")

# HUD variables
onready var _p1_HP_bar := $CanvasLayer/HUD/HBoxContainer/Player1Container/Player1HP
onready var _p1_name := $CanvasLayer/HUD/HBoxContainer/Player1Container/P1NameAndWins/Player1Name
onready var _p1_wins := $CanvasLayer/HUD/HBoxContainer/Player1Container/P1NameAndWins/Player1Wins
onready var _p2_HP_bar := $CanvasLayer/HUD/HBoxContainer/Player2Container/Player2HP
onready var _p2_name := $CanvasLayer/HUD/HBoxContainer/Player2Container/P2NameAndWins/Player2Name
onready var _p2_wins := $CanvasLayer/HUD/HBoxContainer/Player2Container/P2NameAndWins/Player2Wins
onready var _timer_label := $CanvasLayer/HUD/HBoxContainer/GameTimerContainer/GameTimerLabel
onready var _win_round_label := $CanvasLayer/WinMenu/WinLabelAndButtons/WinLabel

# Used for controling the flow of the game.
onready var _is_game_over := false
onready var _is_input_allowed := false

onready var _tween := $Tween

# Used for synchronizing the animations of the player characters.
onready var _tempo_control := $ControlCharacter/AnimatedSprite

# Player variables
onready var _player1 := $PlayersAndCam/Player1
onready var _player1_animation := $PlayersAndCam/Player1/AnimatedSprite

onready var _player2 := $PlayersAndCam/Player2
onready var _player2_animation := $PlayersAndCam/Player2/AnimatedSprite


func _ready() -> void:
	# Set up the HUD.
	# Set the players' HP bar to represent their max HP.
	_p1_HP_bar.value = _player1.max_hitpoints
	_p2_HP_bar.value = _player2.max_hitpoints

	# Force the _timer_label to 99 seconds. This is to prevent a bug where the
	# timer would be set to 0 at the beginning of the game if we were to use
	# the timer's time_left variable.
	_timer_label.text = "99"

	# Sets up the ControlCharacter for tempo timing
	$ControlCharacter.set_speed_of_animation_by_BPM(bpm)
	_tempo_control.animation = "idle"
	_tempo_control.playing = false
	_tempo_control.frame = 0

	# Sets up Player1
	_player1.set_speed_of_animation_by_BPM(bpm)
	_player1.hide()
	_player1.grid_number = 0
	set_position(_player1, _player1.grid_number)
	_player1_animation.animation = "idle"
	_player1_animation.playing = false
	_player1_animation.frame = 0
	_player1_animation.flip_h = false
	_player1.player_number = 1

	# Sets up Player2
	_player2.set_speed_of_animation_by_BPM(bpm)
	_player2.hide()
	_player2.grid_number = 8
	set_position(_player2, _player2.grid_number)
	_player2_animation.animation = "idle"
	_player2_animation.playing = false
	_player2_animation.frame = 0
	_player2_animation.flip_h = true
	_player2.player_number = 2

	# Hide the debug information at the beginning of the game.
	$CanvasLayer/Debug.hide()

	# Starts the game.
	$StartTimer.start()


func _unhandled_input(_event: InputEvent) -> void:
	# Allow the input if the game is not over and input is allowed.
	if ! _is_game_over and _is_input_allowed:
		# Flip the player position  when they are on the opposite sides of each 
		# other. They currently cant't do this as they cannot jump over each 
		# other.
		if _player1.position.x > _player2.position.x:
			_player1_animation.flip_h = true
			_player2_animation.flip_h = false
		else:
			_player1_animation.flip_h = false
			_player2_animation.flip_h = true

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
			if _player1.grid_number != 0 and _player1.grid_number != _player2.grid_number + 1:
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player1.is_allowed_input
				):
					_player1.grid_number -= 1
					set_position(_player1, _player1.grid_number)
					_player1.is_allowed_input = false
		if Input.is_action_just_pressed("p1_right"):
			if _player1.grid_number != 8 and _player1.grid_number != _player2.grid_number - 1:
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player1.is_allowed_input
				):
					_player1.grid_number += 1
					set_position(_player1, _player1.grid_number)
					_player1.is_allowed_input = false
		if Input.is_action_just_pressed("p1_light_punch"):
			if (
				_player1.grid_number == _player2.grid_number - 1
				or _player1.grid_number == _player2.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player1.is_allowed_input
				):
					if not _player2.is_blocking:
						_player2._on_Character_is_hit(10)
						_player1.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_just_pressed("p1_heavy_punch"):
			if (
				_player1.grid_number == _player2.grid_number - 1
				or _player1.grid_number == _player2.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player1.is_allowed_input
				):
					if not _player2.is_blocking:
						_player2._on_Character_is_hit(20)
						_player1.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_just_pressed("p1_light_kick"):
			if (
				_player1.grid_number == _player2.grid_number - 1
				or _player1.grid_number == _player2.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player1.is_allowed_input
				):
					if not _player2.is_blocking:
						_player2._on_Character_is_hit(10)
						_player1.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_just_pressed("p1_heavy_kick"):
			if (
				_player1.grid_number == _player2.grid_number - 1
				or _player1.grid_number == _player2.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player1.is_allowed_input
				):
					if not _player2.is_blocking:
						_player2._on_Character_is_hit(10)
						_player1.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_pressed("p1_block"):
			_player1.is_blocking = true
		if Input.is_action_just_released("p1_block"):
			_player1.is_blocking = false

		# Player 2 controls
		if Input.is_action_just_pressed("p2_left"):
			if _player2.grid_number != 0 and _player2.grid_number != _player1.grid_number + 1:
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player2.is_allowed_input
				):
					_player2.grid_number -= 1
					set_position(_player2, _player2.grid_number)
					_player2.is_allowed_input = false
		if Input.is_action_just_pressed("p2_right"):
			if _player2.grid_number != 8 and _player2.grid_number != _player1.grid_number - 1:
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player2.is_allowed_input
				):
					_player2.grid_number += 1
					set_position(_player2, _player2.grid_number)
					_player2.is_allowed_input = false
		if Input.is_action_just_pressed("p2_light_punch"):
			if (
				_player2.grid_number == _player1.grid_number - 1
				or _player2.grid_number == _player1.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player2.is_allowed_input
				):
					if not _player1.is_blocking:
						_player1._on_Character_is_hit(10)
						_player2.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_just_pressed("p2_heavy_punch"):
			if (
				_player2.grid_number == _player1.grid_number - 1
				or _player2.grid_number == _player1.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player2.is_allowed_input
				):
					if not _player1.is_blocking:
						_player1._on_Character_is_hit(20)
						_player2.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_just_pressed("p2_light_kick"):
			if (
				_player2.grid_number == _player1.grid_number - 1
				or _player2.grid_number == _player1.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player2.is_allowed_input
				):
					if not _player1.is_blocking:
						_player1._on_Character_is_hit(10)
						_player2.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_just_pressed("p2_heavy_kick"):
			if (
				_player2.grid_number == _player1.grid_number - 1
				or _player2.grid_number == _player1.grid_number + 1
			):
				if (
					(_tempo_control.frame <= END_FRAME or _tempo_control.frame >= START_FRAME)
					and _player2.is_allowed_input
				):
					if not _player1.is_blocking:
						_player1._on_Character_is_hit(20)
						_player2.is_allowed_input = false
			else:
				# This will change in a future update
				pass
		if Input.is_action_pressed("p2_block"):
			_player2.is_blocking = true
		if Input.is_action_just_released("p2_block"):
			_player2.is_blocking = false


func _process(_delta: float) -> void:
	# Make sure that the frame number for the players' sprites
	# are the same as the control sprite.
	_player1_animation.frame = _tempo_control.frame
	_player2_animation.frame = _tempo_control.frame

	if _tempo_control.frame == END_FRAME:
		_player1.is_allowed_input = true
		_player2.is_allowed_input = true

	# Show the time remaining for the first round to start at the beginning of
	# a game.
	if not $StartTimer.is_stopped():
		$CanvasLayer/StartTimerLabel.text = "Round begins in:\n" + str(int($StartTimer.time_left))

	# Show the time remaining for the next round to start after a round ends.
	if not $PostWinTimer.is_stopped():
		$CanvasLayer/StartTimerLabel.text = "Round begins in:\n" + str(int($PostWinTimer.time_left))

	# This if statement is to prevent a bug where the timer would be set to 0
	# at the beginning of the game if we were to use the timer's time_left
	# variable.
	if not $GameTimer.is_stopped():
		_timer_label.text = str(int($GameTimer.time_left))

	# Update the players' HP bars with their current hitpoints.
	_p1_HP_bar.value = _player1.hitpoints
	_p2_HP_bar.value = _player2.hitpoints

	# Update the debug information's frame rate, animation frame rate, and tempo.
	$CanvasLayer/Debug/FrameRate.text = (
		"Frame Rate: "
		+ str(Engine.get_frames_per_second())
		+ " FPS"
	)
	$CanvasLayer/Debug/AnimationFrameRate.text = (
		"Animation Frame Rate: "
		+ str(_tempo_control.frames.get_animation_speed("idle"))
		+ " FPS"
	)
	$CanvasLayer/Debug/Tempo.text = "Tempo " + str(bpm) + " BPM"


# Sets the position of the player characters.
# main_player is the player that is being controlled, the grid number is the 
# grid_number that the position is being set to.
func set_position(main_player: Character, grid_number: int) -> void:
	_tween.interpolate_property(
		main_player,
		"position",
		main_player.position,
		get_node("Position" + str(grid_number)).position,
		.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	_tween.start()


# When the StartTimer times out, show the Character classes, play their sprites,
# allow input, play the music, then start the game timer.
func _on_StartTimer_timeout() -> void:
	_player1.show()
	_player1_animation.playing = true

	_player2.show()
	_player2_animation.playing = true

	_tempo_control.playing = true

	_is_input_allowed = true

	$CanvasLayer/StartTimerLabel.hide()

	$AudioStreamPlayer.playing = true

	$GameTimer.start()


# If the game ends before either player defeats the other, disable input, set
# _is_game_over to true, and if either player has more HP than the other, show
# the win menu with the label showing that the winning player won the game.
# If they tie, show that they tie.
func _on_GameTimer_timeout() -> void:
	_is_game_over = true
	_is_input_allowed = false
	if _player1.hitpoints > _player2.hitpoints:
		$CanvasLayer/WinMenu.show()
		_win_round_label.text = "Player 1 wins the game!"
	elif _player2.hitpoints > _player1.hitpoints:
		$CanvasLayer/WinMenu.show()
		_win_round_label.text = "Player 2 wins the game!"
	else:
		$CanvasLayer/WinMenu.show()
		_win_round_label.text = "Tie! No one wins!"


# When player 1 wins a round, increment their wins. If they have 1 win,
# show that they have won a round, pause the game timer and input, reset their
# HP, and begin a countdown for the next round. If they have two wins, show
# that they have won two rounds, set _is_game_over to true and _is_input_allowed
# to false, stop the game timer and show the win menu with the lable showing
# that player 1 has won the round.
func _on_Player1_won_round() -> void:
	_player1.wins += 1
	if _player1.wins == 1:
		_p1_wins.texture = _one_win
		$GameTimer.paused = true
		_is_input_allowed = false
		$CanvasLayer/StartTimerLabel.show()
		_player1.reset_hp()
		_player2.reset_hp()
		$PostWinTimer.start()
	elif _player1.wins == 2:
		_p1_wins.texture = _two_wins
		_is_game_over = true
		_is_input_allowed = false
		$GameTimer.stop()
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinMenu/WinLabelAndButtons/QuitToMainMenuButton.grab_focus()
		_win_round_label.text = "Player 1 wins!"


# When player 2 wins a round, increment their wins. If they have 1 win,
# show that they have won a round, pause the game timer and input, reset their
# HP, and begin a countdown for the next round. If they have two wins, show
# that they have won two rounds, set _is_game_over to true and _is_input_allowed
# to false, stop the game timer and show the win menu with the lable showing
# that player 2 has won the round.
func _on_Player2_won_round() -> void:
	_player2.wins += 1
	if _player2.wins == 1:
		print("Player 2 has one win.")
		_p2_wins.texture = _one_win
		$GameTimer.paused = true
		_is_input_allowed = false
		$CanvasLayer/StartTimerLabel.show()
		_player1.reset_hp()
		_player2.reset_hp()
		$PostWinTimer.start()
	elif _player2.wins == 2:
		print("Player 2 has two wins.")
		_p2_wins.texture = _two_wins
		_is_game_over = true
		_is_input_allowed = false
		$GameTimer.stop()
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinMenu/WinLabelAndButtons/QuitToMainMenuButton.grab_focus()
		_win_round_label.text = "Player 2 wins!"


# When player 1 loses a round, increment their losses and call the method
# to have player 2 win the round.
func _on_Player1_lost_round() -> void:
	_player1.losses += 1
	_on_Player2_won_round()


# When player 2 loses a round, increment their losses and call the method
# to have player 1 win the round.
func _on_Player2_lost_round() -> void:
	_player2.losses += 1
	_on_Player1_won_round()


# When the post-win timer times out, if the neither of the players haven't won a
# game yet, unpause the game timer, hide the start timer label (which is used
# for showing the time remaining before a new round starts with the post-win
# timer), enable input, and reset the players' hitpoints (.
func _on_PostWinTimer_timeout() -> void:
	if _player1.wins != 2 or _player2.wins != 2:
		$GameTimer.paused = false
		$CanvasLayer/StartTimerLabel.hide()
		_is_input_allowed = true
		_player1.reset_hp()
		_player2.reset_hp()
