extends Area2D

# Signals whether the player wins the round (for scoring).
signal win_round

# Signals whether the player wins the round (to play a "lose round" animation).
signal lose_round

# Signals whether the player wins the game (by winning two rounds).
signal win_game

# Signals whether the player loses the game (to play a "lose game" animation).
signal lose_game

# Signals whether the player gets hit (to play a hit animation and to do damage).
signal is_hit(damage)

# Signals whether the player performs a hit.
signal hits(damage)

# Max hitpoints of the character. Once this reaches 0, the player
# is defeated and the opponent wins for the round.
export (int) var max_hitpoints = 200

# The character's current hitpoints.
var hitpoints

# The character selected.
export (PackedScene) var Character

# Signifies which player an instanced Character is.
# 1 is player 1, 2 is player 2. The default player should be player 1.
export (int) var player_number = 1

# Standard tempo the animations are timed to in beats per minute.
const default_bpm = 120.0

# Standard framerate that animations are timed to in frames per second.
const default_fps = 60.0

# The multiplier for adjusting the speed of the animation by BPM.
# See the function "set_speed_of_animation_by_BPM".
const default_animation_factor = default_fps / default_bpm

# Used for movement on the one-dimensional grid in a stage.
var grid_number

# Round wins.
onready var wins = 0

# Round losses.
onready var losses = 0

# Prevents an opponent from doing damage when true.
onready var is_blocking = false

func _ready():
	reset_hp()

# Sets the speed of the animations by bpm.
func set_speed_of_animation_by_BPM(bpm):
	var new_fps = bpm * default_animation_factor
	$AnimatedSprite.frames.set_animation_speed("idle", new_fps)

# After the character is defeated (or a game begins), restore their HP.
func reset_hp():
	hitpoints = max_hitpoints

# Not implemented in this scene.
func _on_Character_win_round():
	# Play a win round animation.
	pass

# Not implemented in this scene.
func _on_Character_lose_round():
	# Play a lose round animation.
	pass

# Not implemented in this scene.
func _on_Character_lose_game():
	# Play a lose game animation
	pass

# Not implemented in this scene.
func _on_Character_win_game():
	# Play a victory animaiton.
	pass

# When the character gets hit, deal the amount of damage done and subtract it 
# from their hitpoints. If they are at or below 0 hitpoints, signal that they
# lost the round.
func _on_Character_is_hit(damage):
	hitpoints -= damage
	if hitpoints <= 0:
		hitpoints = 0
		emit_signal("lose_round")

# When the player hits an opponent, deal the damage to the opponent.
func _on_Character_hits(damage):
	return damage
