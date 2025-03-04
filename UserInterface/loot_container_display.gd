extends CenterContainer

@onready var grid_container: GridContainer = $PanelContainer/VBoxContainer/GridContainer
@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleTexture/TitleLabel

var current_container : LootContainer

func _ready() -> void:
	visible = false

func close() -> void:
	if is_instance_valid(current_container):
		for item in grid_container.get_children():
			grid_container.remove_child(item)
			current_container.add_child(item)
			item.visible = false
		
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func open(loot: LootContainer) -> void:
	current_container = loot
	if visible:
		close()
	else:
		title_label.text = loot.name.capitalize()
		for item in loot.get_items():
			current_container.remove_child(item)
			grid_container.add_child(item)
			item.visible = true
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
