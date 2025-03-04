extends Control
class_name Inventory

@onready var level_display_label: Label = %LevelDisplayLabel

@onready var strength_value: Label = %StrengthValue
@onready var agility_value: Label = %AgilityValue
@onready var endurance_value: Label = %EnduranceValue
@onready var speed_value: Label = %SpeedValue
@onready var attack_value: Label = %AttackValue
@onready var item_grid: GridContainer = %ItemGrid
@onready var gold_label: Label = %GoldLabel
@onready var weapon_slot: CenterContainer = %WeaponSlot
@onready var sheild_slot: CenterContainer = %SheildSlot
@onready var armor_slot: CenterContainer = %ArmorSlot

@onready var player : Player = get_parent().player
@onready var gold : int = 0:
	set(value):
		gold = value
		gold_label.text = str(gold) + "g"
		
func _ready() -> void:
	update_stats()

func update_stats() -> void:
	strength_value.text = str(player.stats.strength.ability_score)
	speed_value.text = str(player.stats.speed.ability_score)
	endurance_value.text = str(player.stats.endurance.ability_score)
	agility_value.text = str(player.stats.agility.ability_score)
	level_display_label.text = "Level: %s" %[player.stats.level]

func update_gear_stats() -> void:
	attack_value.text = str(get_weapon_value())

func get_weapon_value() -> int:
	var damage = 10
	damage += player.stats.get_damage_modifier()
	return damage


func _on_texture_button_pressed() -> void:
	get_parent().close_menu()

func add_item(icon: ItemIcon) -> void:
	for connection in icon.interact.get_connections():
		icon.interact.disconnect(connection["callable"])
	icon.get_parent().remove_child(icon)
	item_grid.add_child(icon)
	icon.interact.connect(interact)

func add_currency(currency_in: int) -> void:
	print(gold)
	gold += currency_in

func equip_item(item: ItemIcon, item_slot: CenterContainer) -> void:
	for child in item_slot.get_children():
		add_item(child)
	item.get_parent().remove_child(item)
	item_slot.add_child(item)

func interact(item: ItemIcon) -> void:
	if item is WeaponIcon:
		equip_item(item, weapon_slot)
	
	update_gear_stats()
