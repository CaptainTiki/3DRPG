extends ItemIcon
class_name CurrencyIcon

@export var value : int

func _ready() -> void:
	stat_label.text = "+" + str(value)
	item_name_label.text = "Gold"
