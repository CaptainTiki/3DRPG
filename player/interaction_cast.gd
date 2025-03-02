extends ShapeCast3D

func check_interactions() -> void:
	for collision in get_collision_count():
		var collider = get_collider(collision)
		if collider is LootContainer:
			if Input.is_action_just_pressed("Right_Click"):
				print(collider.get_items())
		
