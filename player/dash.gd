extends Node3D

@export var player: Player 

@onready var timer: Timer = $Timer

var direction := Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if not timer.is_stopped():
		return
	if Input.is_action_just_pressed("Dash"):
		direction = player.get_movement_direction()
		
		if not direction.is_zero_approx(): #if direction is approx zero - then we aren't moving
			print("stuff")
			timer.start(1.0)
