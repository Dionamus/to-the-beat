extends Node

# Tempo of the stage in beats per minute. ONLY USE FOR DEBUGGING.
# This is meant to be passed from the music select screen (not implmented yet).
# The default value is 120 BPM because that's the speed the animations are
# tied to.
export (int) var bpm = 120.0

# Note: Do not assign the position markers to other variables. It will throw
# errors in the debugger. -Brandon Hawkins

var is_game_over = false

func _ready():
	$Player1.set_speed_of_animation_by_BPM(bpm)
	$Player1.hide()
	$Player1.position = $Position0.position
	$Player1/AnimatedSprite.animation = "idle"
	$Player1/AnimatedSprite.playing = false
	$Player1/AnimatedSprite.frame = 0
	$Player1/AnimatedSprite.flip_h = false
	$Player1.player = 0
	
	$Player2.hide()
	$Player2.set_speed_of_animation_by_BPM(bpm)
	$Player2.position = $Position8.position
	$Player2/AnimatedSprite.animation = "idle"
	$Player2/AnimatedSprite.playing = false
	$Player2/AnimatedSprite.frame = 0
	$Player2/AnimatedSprite.flip_h = true
	$Player2.player = 1
	
	$StartTimer.start()
	pass

func _process(delta):
	if !is_game_over:
		if $Player1.position.x >= $Player2.position.x and $Player2.position.x <= $Player1.position.x:
			$Player1/AnimatedSprite.flip_h = true
			$Player2/AnimatedSprite.flip_h = false
		else:
			$Player1/AnimatedSprite.flip_h = false
			$Player2/AnimatedSprite.flip_h = true
	pass


func _on_StartTimer_timeout():
	$Player1.show()
	$Player1/AnimatedSprite.playing = true
	
	$Player2.show()
	$Player2/AnimatedSprite.playing = true
	
	$GameTimer.start()
	pass

func _on_GameTimer_timeout():
	is_game_over = true
	pass # replace with function body
