extends VBoxContainer

func _ready() -> void:
	$Preview.texture = $Gallery.get_item_icon(0)

func _on_Gallery_item_activated(index) -> void:
	$Preview.texture = $Gallery.get_item_icon(index)
