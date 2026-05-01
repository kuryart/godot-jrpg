# inventory.gd
class_name Inventory extends Resource

@export var items: Dictionary[Item, int] = {}
@export var equippables: Dictionary[ItemEquippable, int] = {}

func add_item(item: Stuff, amount: int = 1):
	if item is Item:
		items[item as Item] = items.get(item, 0) + amount
	elif item is ItemEquippable:
		equippables[item as ItemEquippable] = equippables.get(item, 0) + amount

func remove_item(item: Stuff, amount: int = 1):
	if item is Item:
		remove_from_dict(items, item, amount)
	elif item is ItemEquippable:
		remove_from_dict(equippables, item, amount)

func remove_from_dict(dict: Dictionary, item: Stuff, amount: int):
	if dict.has(item):
		dict[item] -= amount
		if dict[item] <= 0:
			dict.erase(item)

func get_weapons() -> Dictionary[Weapon, int]:
	var weapons_dict: Dictionary[Weapon, int] = {}
	
	for item in equippables:
		if item is Weapon:
			weapons_dict[item as Weapon] = equippables[item]
			
	return weapons_dict

func get_armors() -> Dictionary[Armor, int]:
	var armors_dict: Dictionary[Armor, int] = {}
	
	for item in equippables:
		if item is Armor:
			armors_dict[item as Armor] = equippables[item]
			
	return armors_dict

func get_accessories() -> Dictionary[Accessory, int]:
	var accessories_dict: Dictionary[Accessory, int] = {}
	
	for item in equippables:
		if item is Accessory:
			accessories_dict[item as Accessory] = equippables[item]
			
	return accessories_dict

func get_heads() -> Dictionary[Head, int]:
	var heads_dict: Dictionary[Head, int] = {}
	
	for item in equippables:
		if item is Head:
			heads_dict[item as Head] = equippables[item]
			
	return heads_dict

func get_shields() -> Dictionary[Shield, int]:
	var shields_dict: Dictionary[Shield, int] = {}
	
	for item in equippables:
		if item is Shield:
			shields_dict[item as Shield] = equippables[item]
			
	return shields_dict
