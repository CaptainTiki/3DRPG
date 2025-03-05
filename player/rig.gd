extends Node3D

@export var animation_speed: float = 10.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var skeleton_3d: Skeleton3D = $CharacterRig/GameRig/Skeleton3D
@onready var shield_slot: Node3D = %ShieldSlot
@onready var weapon_slot: Node3D = %WeaponSlot

@onready var villager_meshes: Array[MeshInstance3D] = [
	$CharacterRig/GameRig/Skeleton3D/Villager_01,
	$CharacterRig/GameRig/Skeleton3D/Villager_02
	]

@onready var knight_steel: MeshInstance3D = $CharacterRig/GameRig/Skeleton3D/Knight_01
@onready var knight_iron: MeshInstance3D = $CharacterRig/GameRig/Skeleton3D/Knight_02


signal heavy_attack

var run_path: String = "parameters/MoveSpace/blend_position"
var run_weight_target := -1.0

func _physics_process(delta: float) -> void:
	animation_tree[run_path] = move_toward(
		animation_tree[run_path], 
		run_weight_target,
		delta * animation_speed
	)

func update_animation_tree(direction: Vector3) -> void:
	if direction.is_zero_approx():
		run_weight_target = -1.0 # idle
	else:
		run_weight_target = 1.0 # running

func travel(animation_name: String)-> void:
	playback.travel(animation_name)

func is_idle() -> bool:
	return playback.get_current_node() == "MoveSpace" #MoveSpace is the name of the animation tree node

func is_slashing() -> bool:
	return playback.get_current_node() == "Slash"

func is_overhead_attack() -> bool:
	return playback.get_current_node() in ["Overhead", "OverheadRecover"]

func is_dashing() -> bool:
	return playback.get_current_node() == "Dash"

func set_active_mesh(active_mesh:MeshInstance3D) -> void:
	for child in skeleton_3d.get_children():
		child.visible = false
	active_mesh.visible = true


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Overhead":
		heavy_attack.emit()

func replace_shield(shield_scene: PackedScene) -> void:
	for child in shield_slot.get_children():
		child.queue_free()
	var new_shield := shield_scene.instantiate()
	shield_slot.add_child(new_shield)

func replace_weapon(weapon_scene: PackedScene) -> void:
	for child in weapon_slot.get_children():
		child.queue_free()
	var new_weapon := weapon_scene.instantiate()
	weapon_slot.add_child(new_weapon)

func replace_armor(armor_type: ArmorIcon.armor_type) -> void:
	match armor_type:
		ArmorIcon.armor_type.IRON_PLATE:
			set_active_mesh(knight_iron)
		ArmorIcon.armor_type.STEEL_PLATE:
			set_active_mesh(knight_steel)
		_:
			printerr("armor type invalid. ID: %s" % armor_type)
