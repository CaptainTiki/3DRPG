extends Node3D

const DAMAGE_NUMBER = preload("res://player/damage_number.tscn")
func spawn_damage_number(damage: int, color: Color, position_in: Vector3) -> void:
	var new_number = DAMAGE_NUMBER.instantiate()
	print("Instantiated node:", new_number)
	print("Script path:", new_number.get_script())

	if new_number.has_method("setup"):
		new_number.setup(damage, color, position_in)
		add_child(new_number)
	else:
		print("Error: setup() method not found on instantiated object!")
