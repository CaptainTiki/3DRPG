extends SpringArm3D

@export var target: Node3D
##lower is smoother, higher is snappier
@export var decay: float = 15.0

func _physics_process(delta: float) -> void:
	global_transform = global_transform.interpolate_with(
		target.global_transform,
		1.0 - exp(-decay * delta)
		)
