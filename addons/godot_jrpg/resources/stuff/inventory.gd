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
