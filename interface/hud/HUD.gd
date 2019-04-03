extends MarginContainer

# Objects for the players in a stage.
onready var p1_object = $"../../Player1"
onready var p2_object = $"../../Player2"

# Shortening the player information to variables
onready var p1_HP_bar = $HBoxContainer/Player1Container/Player1HP
onready var p1_name = $HBoxContainer/Player1Container/P1NameAndWins/Player1Name
onready var p1_wins = $HBoxContainer/Player1Container/P1NameAndWins/Player1Wins

onready var p2_HP_bar = $HBoxContainer/Player2Container/Player2HP
onready var p2_name = $HBoxContainer/Player2Container/P2NameAndWins/Player2Name
onready var p2_wins = $HBoxContainer/Player2Container/P2NameAndWins/Player2Wins

onready var timer_label = $HBoxContainer/GameTimerContainer/GameTimerLabel
onready var timer = $"../../GameTimer"

# Preload images for the win counters.
var no_wins = preload("res://interface/hud/no_wins.png")
var p1_one_win = preload("res://interface/hud/p1_one_win.png")
var p2_one_win = preload("res://interface/hud/p2_one_win.png")
var two_wins = preload("res://interface/hud/two_wins.png")

func _ready():
	# Set the players' HP bar to represent their max HP.
	p1_HP_bar.value = p1_object.max_hitpoints
	p2_HP_bar.value = p2_object.max_hitpoints
	
	# Force the timer_label to 99 seconds. This is to prevent a bug where the
	# timer would be set to 0 at the beginning of the game if we were to use
	# the timer's time_left variable.
	timer_label.text = "99"

func _process(delta):
	# This if statement is to prevent a bug where the timer would be set to 0
	# at the beginning of the game if we were to use the timer's time_left
	# variable.
	if not timer.is_stopped():
		timer_label.text = str(int(timer.time_left))
	
	p1_HP_bar.value = p1_object.hitpoints
	p2_HP_bar.value = p2_object.hitpoints
