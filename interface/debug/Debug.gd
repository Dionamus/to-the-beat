extends VBoxContainer

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
				if !visible:
					show()
				elif visible:
					hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$FrameRate.text = "Frame Rate: " + str(Engine.get_frames_per_second()) + " FPS"
	$AnimationFrameRate.text = "Animation Frame Rate: " + str(tempo_timer.frames.get_animation_speed("idle")) + " FPS"
	$Tempo.text = "Tempo " + str(stage.bpm) + " BPM"
	pass
