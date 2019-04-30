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

func _ready():
	# Set up the HUD.
	# Set the players' HP bar to represent their max HP.
	p1_HP_bar.value = $FollowCamera/Player1.max_hitpoints
	p2_HP_bar.value = $FollowCamera/Player2.max_hitpoints
	
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
	$FollowCamera/Player1.set_speed_of_animation_by_BPM(bpm)
	$FollowCamera/Player1.hide()
	$FollowCamera/Player1.grid_number = 0
	set_position($FollowCamera/Player1, $FollowCamera/Player1.grid_number)
	$FollowCamera/Player1/AnimatedSprite.animation = "idle"
	$FollowCamera/Player1/AnimatedSprite.playing = false
	$FollowCamera/Player1/AnimatedSprite.frame = 0
	$FollowCamera/Player1/AnimatedSprite.flip_h = false
	$FollowCamera/Player1.player_number = 1
	
	# Sets up Player2
	$FollowCamera/Player2.set_speed_of_animation_by_BPM(bpm)
	$FollowCamera/Player2.hide()
	$FollowCamera/Player2.grid_number = 8
	set_position($FollowCamera/Player2, $FollowCamera/Player2.grid_number)
	$FollowCamera/Player2/AnimatedSprite.animation = "idle"
	$FollowCamera/Player2/AnimatedSprite.playing = false
	$FollowCamera/Player2/AnimatedSprite.frame = 0
	$FollowCamera/Player2/AnimatedSprite.flip_h = true
	$FollowCamera/Player2.player_number = 2
	
	$CanvasLayer/Debug.hide()
	
	# Starts the game 
	$StartTimer.start()

func _unhandled_input(event):
	# Allow the input if the game is not over and input is allowed.
	if !is_game_over and is_input_allowed:
		# Flip the player position  when they are on the opposite sides of each other.
		if $FollowCamera/Player1.position.x > $FollowCamera/Player2.position.x and $FollowCamera/Player2.position.x < $FollowCamera/Player1.position.x:
			$FollowCamera/Player1/AnimatedSprite.flip_h = true
			$FollowCamera/Player2/AnimatedSprite.flip_h = false
		else:
			$FollowCamera/Player1/AnimatedSprite.flip_h = false
			$FollowCamera/Player2/AnimatedSprite.flip_h = true
		
		# Tempo controls
		# FIXME: Flesh out the controls more.
		
		# Player 1 controls
		if Input.is_action_just_pressed("p1_left"):
			if $FollowCamera/Player1.grid_number != 0 and $FollowCamera/Player1.grid_number != $FollowCamera/Player2.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					$FollowCamera/Player1.grid_number -= 1
					set_position($FollowCamera/Player1, $FollowCamera/Player1.grid_number)
		if Input.is_action_just_pressed("p1_right"):
			#breakpoint
			if $FollowCamera/Player1.grid_number != 8 and $FollowCamera/Player1.grid_number != $FollowCamera/Player2.grid_number - 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					$FollowCamera/Player1.grid_number += 1
					set_position($FollowCamera/Player1, $FollowCamera/Player1.grid_number)
		if Input.is_action_just_pressed("p1_front_punch"):
			if $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number - 1 or $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player2.is_blocking:
						$FollowCamera/Player2._on_Character_is_hit(10)
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p1_back_punch"):
			if $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number - 1 or $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player2.is_blocking:
						$FollowCamera/Player2._on_Character_is_hit(20)
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p1_front_kick"):
			if $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number - 1 or $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player2.is_blocking:
						$FollowCamera/Player2._on_Character_is_hit(10)
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p1_rear_kick"):
			if $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number - 1 or $FollowCamera/Player1.grid_number == $FollowCamera/Player2.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player2.is_blocking:
						$FollowCamera/Player2._on_Character_is_hit(10)
			else:
				# This will change in a future update
				return
		if Input.is_action_pressed("p1_block"):
			$FollowCamera/Player1.is_blocking = true
		if Input.is_action_just_released("p1_block"):
			$FollowCamera/Player1.is_blocking = false
		if Input.is_action_just_pressed("p1_pause"):
#					breakpoint
			if $CanvasLayer/PauseMenu.visible:
				$CanvasLayer/PauseMenu.hide()
				get_tree().paused = false
			else:
				get_tree().paused = true
				$CanvasLayer/PauseMenu.show()
			
		# Player 2 controls
		if Input.is_action_just_pressed("p2_left"):
			if $FollowCamera/Player2.grid_number != 0 and $FollowCamera/Player2.grid_number != $FollowCamera/Player1.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					$FollowCamera/Player2.grid_number -= 1
					set_position($FollowCamera/Player2, $FollowCamera/Player2.grid_number)
		if Input.is_action_just_pressed("p2_right"):
			if $FollowCamera/Player2.grid_number != 8 and $FollowCamera/Player2.grid_number != $FollowCamera/Player1.grid_number - 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					$FollowCamera/Player2.grid_number += 1
					set_position($FollowCamera/Player2, $FollowCamera/Player2.grid_number)
		if Input.is_action_just_pressed("p2_front_punch"):
			if $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number - 1 or $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player1.is_blocking:
						$FollowCamera/Player1._on_Character_is_hit(10)
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p2_back_punch"):
			if $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number - 1 or $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player1.is_blocking:
						$FollowCamera/Player1._on_Character_is_hit(20)
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p2_front_kick"):
			if $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number - 1 or $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player1.is_blocking:
						$FollowCamera/Player1._on_Character_is_hit(10)
			else:
				# This will change in a future update
				return
		if Input.is_action_just_pressed("p2_rear_kick"):
			if $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number - 1 or $FollowCamera/Player2.grid_number == $FollowCamera/Player1.grid_number + 1:
				if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
					if not $FollowCamera/Player1.is_blocking:
						$FollowCamera/Player1._on_Character_is_hit(20)
			else:
				# This will change in a future update
				return
		if Input.is_action_pressed("p2_block"):
			$FollowCamera/Player2.is_blocking = true
		if Input.is_action_just_released("p2_block"):
			$FollowCamera/Player2.is_blocking = false
		if Input.is_action_just_pressed("p2_pause"):
			if not $CanvasLayer/PauseMenu.visible:
				get_tree().paused = true
				$CanvasLayer/PauseMenu.show()
			else:
				$CanvasLayer/PauseMenu.hide()
				get_tree().paused = false

func _process(delta):
	# Make sure that the frame number for the players' sprites
	# are the same as the control sprite.
	$FollowCamera/Player1/AnimatedSprite.frame = tempo_control.frame
	$FollowCamera/Player2/AnimatedSprite.frame = tempo_control.frame
	
	if not $StartTimer.is_stopped():
		$CanvasLayer/StartTimerLabel.text = "Round begins in:\n" + str(int($StartTimer.time_left))
	
	if not $PostWinTimer.is_stopped():
		$CanvasLayer/StartTimerLabel.text = "Round begins in:\n" + str(int($PostWinTimer.time_left))
	
	# This if statement is to prevent a bug where the timer would be set to 0
	# at the beginning of the game if we were to use the timer's time_left
	# variable.
	if not $GameTimer.is_stopped():
		timer_label.text = str(int($GameTimer.time_left))
	
	p1_HP_bar.value = $FollowCamera/Player1.hitpoints
	p2_HP_bar.value = $FollowCamera/Player2.hitpoints
	
	$CanvasLayer/Debug/FrameRate.text = "Frame Rate: " + str(Engine.get_frames_per_second()) + " FPS"
	$CanvasLayer/Debug/AnimationFrameRate.text = "Animation Frame Rate: " + str(tempo_control.frames.get_animation_speed("idle")) + " FPS"
	$CanvasLayer/Debug/Tempo.text = "Tempo " + str(bpm) + " BPM"

# Sets the position of the player characters.
# main_player is the player that is being controlled, the grid number is the 
# grid_number that the position is being set to.
func set_position(main_player, grid_number):
	if grid_number == 0:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position0.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 1:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position1.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 2:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position2.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 3:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position3.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 4:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position4.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 5:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position5.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 6:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position6.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 7:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position7.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	elif grid_number == 8:
		tween.interpolate_property(main_player, "position", main_player.position,
		$Position8.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

# When the StartTimer times out, show the Character classes, play their sprites,
# start the game timer, and then allow input.
func _on_StartTimer_timeout():
	$FollowCamera/Player1.show()
	$FollowCamera/Player1/AnimatedSprite.playing = true
	
	$FollowCamera/Player2.show()
	$FollowCamera/Player2/AnimatedSprite.playing = true
	
	tempo_control.playing = true
	
	is_input_allowed = true
	
	$CanvasLayer/StartTimerLabel.hide()
	
	$AudioStreamPlayer.playing = true
	
	$GameTimer.start()

func _on_GameTimer_timeout():
	is_game_over = true
	is_input_allowed = false
	if $FollowCamera/Player1.hitpoints > $FollowCamera/Player2.hitpoints:
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinLabel.text = "Player 1 wins the game!"
	elif $FollowCamera/Player2.hitpoints > $FollowCamera/Player1.hitpoints:
		$CanvasLayer/WinMenu.show()
		$CanvasLayer/WinLabel.text = "Player 2 wins the game!"
	else:
		$CanvasLayer/WinLabel.text = "Tie! No one wins!"

func _on_Player1_win_round():
	$FollowCamera/Player1.wins += 1
	if $FollowCamera/Player1.wins == 1:
		print("Player 1 has one win.")
		p1_wins.texture = p1_one_win
		$GameTimer.paused = true
		is_input_allowed = false
		$CanvasLayer/StartTimerLabel.show()
		$PostWinTimer.start()
		$FollowCamera/Player1.reset_hp()
		$FollowCamera/Player2.reset_hp()
	elif $FollowCamera/Player1.wins == 2:
		print("Player 1 has two wins.")
		p1_wins.texture = two_wins
		is_game_over = true
		is_input_allowed = false
		$GameTimer.stop()
		$CanvasLayer/WinMenu.show()
		win_round_label.text = "Player 1 wins!"

func _on_Player2_win_round():
#	breakpoint
	$FollowCamera/Player2.wins += 1
	if $FollowCamera/Player2.wins == 1:
		print("Player 2 has one win.")
		p2_wins.texture = p2_one_win
		$GameTimer.paused = true
		is_input_allowed = false
		$CanvasLayer/StartTimerLabel.show()
		$PostWinTimer.start()
		$FollowCamera/Player1.reset_hp()
		$FollowCamera/Player2.reset_hp()
	elif $FollowCamera/Player2.wins == 2:
		print("Player 2 has two wins.")
		p2_wins.texture = two_wins
		is_game_over = true
		is_input_allowed = false
		$GameTimer.stop()
		$CanvasLayer/WinMenu.show()
		win_round_label.text = "Player 2 wins!"

func _on_Player1_lose_round():
	$FollowCamera/Player1.losses += 1
	_on_Player2_win_round()

func _on_Player2_lose_round():
	$FollowCamera/Player2.losses += 1
	_on_Player1_win_round()

func _on_PostWinTimer_timeout():
	$GameTimer.paused = false
	$CanvasLayer/StartTimerLabel.hide()
	is_input_allowed = true
	pass # Replace with function body.
