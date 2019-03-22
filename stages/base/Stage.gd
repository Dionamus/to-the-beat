extends Node

# Tempo of the stage in beats per minute. ONLY USE FOR DEBUGGING.
# This is meant to be passed from the music select screen (not implmented yet).
# The default value is 120 BPM because that's the speed the animations are
# tied to.
export (int) var bpm = 120.0

# Note: Do not assign the position markers to other variables. It will throw
# errors in the debugger. -Brandon Hawkins

onready var is_game_over = false

onready var is_input_allowed = false

onready var tween = $Tween

onready var debug_timer = 0

func _ready():
	# Sets up Player1
	$Player1.reset_hp()
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
	$Player1.reset_hp()
	$Player2.set_speed_of_animation_by_BPM(bpm)
	$Player2.hide()
	$Player2.grid_number = 8
	set_position($Player2, $Player2.grid_number)
	$Player2/AnimatedSprite.animation = "idle"
	$Player2/AnimatedSprite.playing = false
	$Player2/AnimatedSprite.frame = 0
	$Player2/AnimatedSprite.flip_h = true
	$Player2.player_number = 2
	
	# Starts the game 
	$StartTimer.start()

func _process(delta):
	# The input
	if !is_game_over and is_input_allowed:
		if $Player1.position.x > $Player2.position.x and $Player2.position.x < $Player1.position.x:
			$Player1/AnimatedSprite.flip_h = true
			$Player2/AnimatedSprite.flip_h = false
		else:
			$Player1/AnimatedSprite.flip_h = false
			$Player2/AnimatedSprite.flip_h = true
		
		# FIXME: Get the tempo timing to work.
		if Input.is_action_pressed("p1_left"):
			if $Player1.grid_number != 0 and $Player1.grid_number != $Player2.grid_number + 1:
				$Player1.grid_number -= 1
				set_position($Player1, $Player1.grid_number)
		if Input.is_action_pressed("p1_right"):
			#breakpoint
			if $Player1.grid_number != 8 and $Player1.grid_number != $Player2.grid_number - 1:
				$Player1.grid_number += 1
				set_position($Player1, $Player1.grid_number)
		if Input.is_action_pressed("p2_left"):
			if $Player2.grid_number != 0 and $Player2.grid_number != $Player2.grid_number + 1:
				$Player2.grid_number -= 1
				set_position($Player2, $Player2.grid_number)
		if Input.is_action_pressed("p2_right"):
			if $Player1.grid_number != 8 and $Player2.grid_number != $Player1.grid_number - 1:
				$Player2.grid_number += 1
				set_position($Player2, $Player2.grid_number)

# Sets the position of the player characters.
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
	
	$GameTimer.start()
	
	is_input_allowed = true

func _on_GameTimer_timeout():
	is_game_over = true
	is_input_allowed = false