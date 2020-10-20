# A 2D fighting game camera that follows sibling nodes.
#
# Note: This camera and whatever is tracked by this camera must be parented
# under a generic Node because Godot 3.2 broke the original functionality.
#
# Credit: GDQuest on YouTube
extends Camera2D

export (float, 0.02, 0.5) var zoom_offset := 0.02

# If `true`, the debug rectangle that contains the sibling Nodes will be drawn.
export var debug_mode := false

# The camera's rectangle.
onready var camera_rect := Rect2()

# The viewport's rectangle.
onready var viewport_rect := Rect2()

# The siblings are part of the parent object of this class. This is to fix a
# bug that broke the camera after updating the engine to 3.2.1.

# The number of Nodes that are also parented with this Node's parent.
onready var _sibling_count := 0

# An array of Nodes that are also parented with this Node's parent.
onready var _siblings = []

# The furthest the camera can zoom in.
const lowest_zoom_in := 0.085

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	_set_sibling_count()
	_set_siblings()
	set_process(_get_sibling_count() > 0)


# Adjusts the position and zoom of the camera when its siblings move.
func _process(_delta: float):
	camera_rect = Rect2(_get_sibling(0).position, Vector2())
	for index in _get_sibling_count():
		if index == 0:
			continue
		camera_rect = camera_rect.expand(_get_sibling(index).position)

	position = calculate_center(camera_rect)
	zoom = calculate_zoom(camera_rect, viewport_rect.size)

	if debug_mode:
		update()


# Calculates the camera's center.
func calculate_center(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2
	)


# Calculates the camera's zoom.
func calculate_zoom(rect: Rect2, viewport_size: Vector2) -> Vector2:
	var zoom_in = max(
			max(lowest_zoom_in, rect.size.x / viewport_size.x + zoom_offset),
			max(lowest_zoom_in, rect.size.y / viewport_size.y + zoom_offset)
		)
	var zoom_out = max(
			limit_right / viewport_size.x, limit_bottom / viewport_size.y
		)
	var new_zoom = min(zoom_in, zoom_out)

	return Vector2(new_zoom, new_zoom)


# Draws the debug rectangle.
func _draw() -> void:
	if not debug_mode:
		return
	draw_rect(camera_rect, Color("#FFFFFF"), false)
	draw_circle(calculate_center(camera_rect), 5, Color("#FFFFFF"))


# Sets the `_sibling_count`.
func _set_sibling_count() -> void:
	for index in get_parent().get_children():
		if index.name != name:
			_sibling_count += 1


# Returns the `_sibling_count`.
func _get_sibling_count() -> int:
	return _sibling_count


# Creates an array of `_siblings`.
func _set_siblings() -> void:
	for index in get_parent().get_children():
		if index.name != name:
			_siblings.append(index)


# Returns the list of `_siblings` as an array.
func _get_siblings() -> Array:
	return _siblings


# Returns a sibling by it's index.
func _get_sibling(idx: int) -> Character:
	return _siblings[idx]
