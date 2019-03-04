extends Area2D

var screensize

# Standard tempo the animations are timed to in beats per minute
var default_bpm = 120

var default_fps = 60

# The multiplier for adjusting the speed of the animation by BPM.
# See the function "set_speed_of_animation_by_BPM
var animation_factor = default_fps / default_bpm

func _ready():
	screensize = get_viewport_rect().size
	pass
	
func set_speed_of_animation_by_BPM(bpm):
	new_fps = bpm * animation_factor
	AnimatedSprite.speed(new_fps)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
