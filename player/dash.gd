extends Node3D

@export var player: Player 

@onready var timer: Timer = $Timer

var direction : Vector3 = Vector3.ZERO
var dash_duration : float = 0.1
var time_remaining : float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if not timer.is_stopped():
		return
	if Input.is_action_just_pressed("Dash"):
		direction = player.get_movement_direction()
		
		if not direction.is_zero_approx(): #if direction is approx zero - then we aren't moving
			player.rig.travel("Dash")
			timer.start(1.0)
			time_remaining = dash_duration

func _physics_process(delta: float) -> void:
	if direction.is_zero_approx():
		return
	player.velocity = direction * player.SPEED * 5
	time_remaining -= delta
	if time_remaining <= 0:
		pass
		direction = Vector3.ZERO
	else:
		pass
