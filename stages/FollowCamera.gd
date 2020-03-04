# Credit: GDQuest on YouTube
extends Camera2D

export(float, 0.1, 0.5) var zoom_offset = 0.2
export var debug_mode = false

onready var camera_rect := Rect2()
onready var viewport_rect := Rect2()

func _ready():
	viewport_rect = get_viewport_rect()
	set_process(get_child_count() > 0)

func _process(_delta):
	camera_rect = Rect2(get_child(0).global_position, Vector2())
	for index in get_child_count():
		if index == 0:
			continue
		camera_rect = camera_rect.expand(get_child(index).global_position)
	
	offset = calculate_center(camera_rect)
	zoom = calculate_zoom(camera_rect, viewport_rect.size)
	
	if debug_mode:
		update()

func calculate_center(rect):
	return Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2
		)

func calculate_zoom(rect, viewport_size):
	var max_zoom = max(
		max(1, rect.size.x / viewport_size.x + zoom_offset),
		max(1, rect.size.y / viewport_size.y + zoom_offset)
		)
	return Vector2(max_zoom, max_zoom)

func _draw():
	if not debug_mode:
		return
	draw_rect(camera_rect, Color("#FFFFFF"), false)
	draw_circle(calculate_center(camera_rect), 5, Color("#FFFFFF"))
