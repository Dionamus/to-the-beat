extends Control

onready var frame_rate = $VBoxContainer/FrameRate
onready var animation_frame_rate = $VBoxContainer/AnimationFrameRate
onready var tempo = $VBoxContainer/Tempo

onready var tempo_timer = $"../../ControlCharacter/AnimatedSprite"
onready var stage = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# When the players hits F10, it'll bring up the debug info.
func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_key_pressed(KEY_F10):
				if !is_visible():
					show()
				elif is_visible():
					hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame_rate.text = "Frame Rate: " + str(Engine.get_frames_per_second()) + " FPS"
	animation_frame_rate.text = "Animation Frame Rate: " + str(tempo_timer.frames.get_animation_speed("idle")) + " FPS"
	tempo.text = "Tempo " + str(stage.bpm) + " BPM"
	pass
