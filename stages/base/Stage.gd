extends Node

# Tempo of the stage in beats per minute. ONLY USE FOR DEBUGGING.
# This is meant to be passed from the music select screen (not implmented yet).
# The default value is 120 BPM because that's the speed the animations are
# tied to.
export (int) var bpm = 120

# Note: Do not assign the position markers to other variables. It will throw
# errors in the debugger. -Brandon Hawkins

onready var is_game_over = false

onready var is_input_allowed = false

onready var tween = $Tween

onready var hud = $Camera2D/HUD

# onready var debug_timer = 0

# The start frame for the tempo timing.
onready var start_frame = 21

# The end frame for the tempo timing.
onready var end_frame = 8

# Used for synchronizing the animations of the player characters.
onready var tempo_control = $ControlCharacter/AnimatedSprite

func _ready():
	# Sets up the ControlCharacter for tempo timing
	$ControlCharacter.set_speed_of_animation_by_BPM(bpm)
	tempo_control.animation = "idle"
	tempo_control.playing = false
	tempo_control.frame = 0
	
	# Sets up Player1
	$Player1.set_speed_of_animation_by_BPM(bpm)
	$Player1.hide()
	$Player1.grid_number = 0
	set_position($Player1, $Player1.grid_number)
	$Player1/AnimatedSprite.animation = "idle"
	$Player1/AnimatedSprite.playing = false
	$Player1/AnimatedSprite.frame = 0
	$Player1/AnimatedSprite.flip_h = false
	$Player1.player_number = 1
	
	# Sets up Player2
	$Player2.set_speed_of_animation_by_BPM(bpm)
	$Player2.hide()
	$Player2.grid_number = 8
	set_position($Player2, $Player2.grid_number)
	$Player2/AnimatedSprite.animation = "idle"
	$Player2/AnimatedSprite.playing = false
	$Player2/AnimatedSprite.frame = 0
	$Player2/AnimatedSprite.flip_h = true
	$Player2.player_number = 2
	
	$Camera2D/Debug.hide()
	
	# Starts the game 
	$StartTimer.start()

func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			# Allow the input if the game is not over and input is allowed.
			if !is_game_over and is_input_allowed:
				# Flip the player position  when they are on the opposite sides of each other.
				if $Player1.position.x > $Player2.position.x and $Player2.position.x < $Player1.position.x:
					$Player1/AnimatedSprite.flip_h = true
					$Player2/AnimatedSprite.flip_h = false
				else:
					$Player1/AnimatedSprite.flip_h = false
					$Player2/AnimatedSprite.flip_h = true
				
				# Tempo controls
				# FIXME: Flesh out the controls more.
				
				# Player 1 controls
				if Input.is_action_just_pressed("p1_left"):
					if $Player1.grid_number != 0 and $Player1.grid_number != $Player2.grid_number + 1:
						if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
							$Player1.grid_number -= 1
							set_position($Player1, $Player1.grid_number)
				if Input.is_action_just_pressed("p1_right"):
					#breakpoint
					if $Player1.grid_number != 8 and $Player1.grid_number != $Player2.grid_number - 1:
						if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
							$Player1.grid_number += 1
							set_position($Player1, $Player1.grid_number)
				if Input.is_action_just_pressed("p1_pause"):
#					breakpoint
					if $Camera2D/PauseMenu.visible == true:
						$Camera2D/PauseMenu.hide()
						get_tree().paused = false
					if $Camera2D/PauseMenu.visible == false:
						get_tree().paused = true
						$Camera2D/PauseMenu.show()
					
				# Player 2 controls
				if Input.is_action_just_pressed("p2_left"):
					if $Player2.grid_number != 0 and $Player2.grid_number != $Player2.grid_number + 1:
						if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
							$Player2.grid_number -= 1
							set_position($Player2, $Player2.grid_number)
				if Input.is_action_just_pressed("p2_right"):
					if $Player1.grid_number != 8 and $Player2.grid_number != $Player1.grid_number - 1:
						if tempo_control.frame <= end_frame or tempo_control.frame >= start_frame:
							$Player2.grid_number += 1
							set_position($Player2, $Player2.grid_number)
				if Input.is_action_just_pressed("p2_pause"):
					if $Camera2D/PauseMenu.visible == false:
						get_tree().paused = true
						$Camera2D/PauseMenu.show()
					if $Camera2D/PauseMenu.visible == true:
						$Camera2D/PauseMenu.hide()
						get_tree().paused = false

func _process(delta):
	# Make sure that the frame number for the players' sprites
	# are the same as the control sprite.
	$Player1/AnimatedSprite.frame = tempo_control.frame
	$Player2/AnimatedSprite.frame = tempo_control.frame
	
	if not $StartTimer.is_stopped():
		$Camera2D/StartTimerLabel.text = "Round begins in:\n" + str(int($StartTimer.time_left))

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
	$Player1.show()
	$Player1/AnimatedSprite.playing = true
	
	$Player2.show()
	$Player2/AnimatedSprite.playing = true
	
	tempo_control.playing = true
	
	is_input_allowed = true
	
	$Camera2D/StartTimerLabel.hide()
	
	$GameTimer.start()

func _on_GameTimer_timeout():
	is_game_over = true
	is_input_allowed = false

func _on_Player1_win_round():
	if $Player1.wins == 1:
		hud.p1_wins = hud.p1_one_win
	if $Player1.wins == 2:
		hud.p1_wins = hud.two_wins

func _on_Player2_win_round():
	if $Player2.wins == 1:
		hud.p2_wins = hud.p2_one_win
	if $Player2.wins == 2:
		hud.p2_wins = hud.two_wins