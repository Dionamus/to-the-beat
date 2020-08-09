# Credit: GDQuest on YouTube
extends Camera2D

export(float, 0.1, 0.5) var zoom_offset := 0.2
export var debug_mode := false

onready var camera_rect := Rect2()
onready var viewport_rect := Rect2()

# The siblings are part of the parent object of this class. This is to fix a
# bug that broke the camera after updating the engine to 3.2.1.
onready var _sibling_count := 0
onready var _siblings = []

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	set_sibling_count()
	set_siblings()
	set_process(get_sibling_count() > 0)

func _process(_delta: float):
	camera_rect = Rect2(get_sibling(0).global_position, Vector2())
	for index in get_sibling_count():
		if index == 0:
			continue
		camera_rect = camera_rect.expand(get_sibling(index).global_position)
	
	position = calculate_center(camera_rect)
	zoom = calculate_zoom(camera_rect, viewport_rect.size)
	
	if debug_mode:
		update()

func calculate_center(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2
		)

func calculate_zoom(rect: Rect2, viewport_size: Vector2) -> Vector2:
	var max_zoom = max(
		max(1, rect.size.x / viewport_size.x + zoom_offset),
		max(1, rect.size.y / viewport_size.y + zoom_offset)
		)
	return Vector2(max_zoom, max_zoom)

func _draw() -> void:
	if not debug_mode:
		return
	draw_rect(camera_rect, Color("#FFFFFF"), false)
	draw_circle(calculate_center(camera_rect), 5, Color("#FFFFFF"))

# Sets the sibling count.
func set_sibling_count() -> void:
	for index in get_parent().get_children():
		if index.name != name:
			_sibling_count += 1

# Returns the sibling count.
func get_sibling_count() -> int:
	return _sibling_count

# Sets the _siblings.
func set_siblings() -> void:
	for index in get_parent().get_children():
		if index.name != name:
			_siblings.append(index)

# Returns the list of _siblings as an array.
func get_siblings() -> Array:
	return _siblings

# Returns a sibling by it's index.
func get_sibling(idx: int):
	return _siblings[idx]
