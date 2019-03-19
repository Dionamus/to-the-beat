extends Area2D

# Hitpoints of the character. Once this reaches 0, the player
# is defeated and the opponent wins
export (int) var hitpoints = 200

# The character selected 
export (PackedScene) var Character

# Signifies which player an instanced Character is.
# 0 is player 1, 1 is player 2.
var player = 0

# Standard tempo the animations are timed to in beats per minute.
const default_bpm = 120.0

# Standard framerate that animations are timed to in frames per second.
const default_fps = 60.0

# The multiplier for adjusting the speed of the animation by BPM.
# See the function "set_speed_of_animation_by_BPM".
const animation_factor = default_fps / default_bpm

func _ready():
	pass

# Sets the speed of the animations by bpm.
func set_speed_of_animation_by_BPM(bpm):
	var new_fps = bpm * animation_factor
	$AnimatedSprite.frames.set_animation_speed("idle", new_fps)
	pass

#func _process(delta):
#	pass
