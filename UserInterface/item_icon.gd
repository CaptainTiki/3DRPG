extends TextureButton
class_name ItemIcon

signal interact(item)

@onready var stat_label = $MarginContainer/StatLabel
@onready var item_name_label: Label = $MarginContainer/ItemNameLabel

func _ready() -> void:
	visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("Left_Click"):
		interact.emit(self)
		
