extends ItemIcon

@export var power : int
@export var item_model: PackedScene

func _ready() -> void:
	stat_label.text = "+" + str(power)
	item_name_label.text = item_model.resource_path.get_file()
	var extension : String = item_model.resource_path.get_extension()
	item_name_label.text = item_name_label.text.rstrip("." + extension)
	item_name_label.text = item_name_label.text.capitalize()
