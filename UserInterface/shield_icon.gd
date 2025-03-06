extends ItemIcon
class_name ShieldIcon

@export var protection : int
@export var item_model: PackedScene

func _ready() -> void:
	visible = false
	stat_label.text = "+" + str(protection)
	item_name_label.text = item_model.resource_path.get_file()
	var extension : String = item_model.resource_path.get_extension()
	item_name_label.text = item_name_label.text.rstrip("." + extension)
	item_name_label.text = item_name_label.text.capitalize()
