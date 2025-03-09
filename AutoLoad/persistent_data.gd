extends Control

@onready var inventory_node: Control = $InventoryNode
@onready var equipped_weapon: Control = $EquippedWeapon
@onready var equipped_shield: Control = $EquippedShield
@onready var equipped_armor: Control = $EquippedArmor

func cache_gear(player: Player) -> void:
	for item in player.user_interface.inventory.item_grid.get_children():
		cache_item(item, inventory_node)
	cache_item(player.user_interface.inventory.get_weapon(), equipped_weapon)
	cache_item(player.user_interface.inventory.get_sheild(), equipped_shield)
	cache_item(player.user_interface.inventory.get_armor(), equipped_armor)

func get_inventory() -> Array:
	return inventory_node.get_children()

func get_equipped_items() -> Array:
	var equipped_items := []
	if equipped_weapon.get_child_count() > 0:
		equipped_items.append(equipped_weapon.get_child(0))
	if equipped_shield.get_child_count() > 0:
		equipped_items.append(equipped_shield.get_child(0))
	if equipped_armor.get_child_count() > 0:
		equipped_items.append(equipped_armor.get_child(0))
	return equipped_items

func cache_item(item: ItemIcon, storage_node: Control) -> void:
	item.get_parent().remove_child(item)
	storage_node.add_child(item)
