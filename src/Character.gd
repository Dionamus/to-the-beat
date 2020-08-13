# Base class for characters.
class_name Character
extends Area2D

# Emitted when the `Character` wins the round (for scoring).
signal won_round

# Emitted when the `Character` wins the round (to play a "lose round" animation).
signal lost_round

# Emitted when the `Character` wins the game (by winning two rounds).
signal won_game

# Emitted when the `Character` loses the game (to play a "lose game" animation).
signal lost_game

# Emitted when the `Character` gets hit. Plays a hit animation and subtracts
# `damage` from `hitpoints`.
signal is_hit(damage)

# Emitted when the `Character` performs a hit, subtracting `damage` from
# `opponent`'s `hitpoints`.
signal hits(damage)

# The standard tempo the animations are timed to in beats per minute.
const DEFAULT_BPM := 120.0

# The standard framerate that animations are timed to in frames per second.
const DEFAULT_FPS := 60.0

# The multiplier for adjusting the speed of the animation by BPM.
# See the function `set_speed_of_animation_by_BPM`.
const DEFAULT_ANIMATION_FACTOR := DEFAULT_FPS / DEFAULT_BPM

# The maximum hitpoints of the character. If `0` or less, the `Character` is
# defeated and the `opponent` wins the round.
export (int) var max_hitpoints := 200

# Signifies which player an instanced `Character` is.
export (int) var player_number := 1

# Represents the `Character`'s position number.
export (int) var grid_number := 0

# The `Character`'s current hitpoints.
var hitpoints := 200

# Round wins.
onready var wins := 0

# Round losses.
onready var losses := 0

# The next two variables will later be implemented as a state machine 

# If `true`, the `Character` is unable to take damage (unless the `opponent`
# breaks the block).
onready var is_blocking := false

# If `true`, the `Character` is unable to attack, move, or block (except if
# they make a counter attack).
onready var is_stunned := false

# If `true`, the `Character` is unable to make any inputs.
onready var is_allowed_input := true


func _ready() -> void:
	reset_hp()


# Sets the speed of the animations by `bpm`.
func set_speed_of_animation_by_BPM(bpm: int) -> void:
	var new_fps = bpm * DEFAULT_ANIMATION_FACTOR
	$AnimatedSprite.frames.set_animation_speed("idle", new_fps)


# Restore the `Character` to `max_hitpoints`.
func reset_hp() -> void:
	hitpoints = max_hitpoints


func _on_Character_won_round() -> void:
	# Play a win round animation.
	pass


func _on_Character_lost_round() -> void:
	# Play a lose round animation.
	pass


func _on_Character_lost_game() -> void:
	# Play a lose game animation
	pass


func _on_Character_won_game() -> void:
	# Play a victory animation.
	pass


func _on_Character_is_hit(damage: int) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		hitpoints = 0
		emit_signal("lost_round")


func _on_Character_hits(damage: int) -> int:
	return damage
