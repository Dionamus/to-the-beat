tool
class_name SelfBuildingItemList
extends ItemList

enum ItemTypes { CHARACTER, STAGE }
export (ItemTypes) var item_type setget set_item_type


func _ready() -> void:
	set_item_type(item_type)


func set_item_type(new_item_type) -> void:
	clear()
	var path: String
	var dir = Directory.new()
	var error
	
	item_type = new_item_type

	match item_type:
		ItemTypes.CHARACTER:
			path = "res://assets/characters/portraits"
		ItemTypes.STAGE:
			path = "res://assets/stagebackgrounds"

	# Populate the item list.
	error = dir.open(path)
	if !error:
		dir.list_dir_begin(true, true)
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".png"):
				add_item(file.trim_suffix(file.right(file.find(".png"))),
						load(dir.get_current_dir() + "/" + file))
			file = dir.get_next()
	else:
		push_error("For some forsaken reason, '" + path + "' does not exist. "
				+ "I wonder why...")
	grab_focus()
