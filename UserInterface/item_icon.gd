extends TextureButton
class_name ItemIcon

signal interact(item)

@onready var stat_label = $MarginContainer
@onready var item_name_label: Label = $MarginContainer/ItemNameLabel


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("click"):
		interact.emit(self)
		
