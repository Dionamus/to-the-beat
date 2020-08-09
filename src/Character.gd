class_name Character
extends Area2D

# Signals whether the player wins the round (for scoring).
signal won_round

# Signals whether the player wins the round (to play a "lose round" animation).
signal lost_round

# Signals whether the player wins the game (by winning two rounds).
signal won_game

# Signals whether the player loses the game (to play a "lose game" animation).
signal lost_game

# Signals whether the player gets hit (to play a hit animation and to do damage).
signal is_hit(damage)

# Signals whether the player performs a hit.
signal hits(damage)

# Standard tempo the animations are timed to in beats per minute.
const DEFAULT_BPM := 120.0

# Standard framerate that animations are timed to in frames per second.
const DEFAULT_FPS := 60.0

# The multiplier for adjusting the speed of the animation by BPM.
# See the function "set_speed_of_animation_by_BPM".
const DEFAULT_ANIMATION_FACTOR := DEFAULT_FPS / DEFAULT_BPM

# Max hitpoints of the character. Once this reaches 0, the player
# is defeated and the opponent wins for the round.
export (int) var max_hitpoints := 200

# Signifies which player an instanced Character is.
# 1 is player 1, 2 is player 2. The default player should be player 1.
export (int) var player_number := 1

# Used for movement on the one-dimensional grid in a stage.
export (int) var grid_number := 0

# The character's current hitpoints.
var hitpoints := 200

# Round wins.
onready var wins := 0

# Round losses.
onready var losses := 0

# Prevents an opponent from doing damage when true.
onready var is_blocking := false

onready var is_stunned := false

onready var is_allowed_input := true


func _ready() -> void:
	reset_hp()


# Sets the speed of the animations by bpm.
func set_speed_of_animation_by_BPM(bpm: int) -> void:
	var new_fps = bpm * DEFAULT_ANIMATION_FACTOR
	$AnimatedSprite.frames.set_animation_speed("idle", new_fps)


# After the character is defeated (or a game begins), restore their HP.
func reset_hp() -> void:
	hitpoints = max_hitpoints


# Not implemented in this scene.
func _on_Character_won_round() -> void:
	# Play a win round animation.
	pass


# Not implemented in this scene.
func _on_Character_lost_round() -> void:
	# Play a lose round animation.
	pass


# Not implemented in this scene.
func _on_Character_lost_game() -> void:
	# Play a lose game animation
	pass


# Not implemented in this scene.
func _on_Character_won_game() -> void:
	# Play a victory animation.
	pass


# When the character gets hit, deal the amount of damage done and subtract it 
# from their hitpoints. If they are at or below 0 hitpoints, signal that they
# lost the round.
func _on_Character_is_hit(damage: int) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		hitpoints = 0
		emit_signal("lose_round")


# When the player hits an opponent, deal the damage to the opponent.
func _on_Character_hits(damage: int) -> int:
	return damage
