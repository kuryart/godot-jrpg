# inventory.gd
class_name Inventory extends Resource

@export var usables: Dictionary[ItemUsable, int] = {}
@export var passives: Dictionary[ItemPassive, int] = {}
@export var equippables: Dictionary[ItemEquippable, int] = {}

func add_item(item: Item, amount: int = 1):
	if item is ItemUsable:
		usables[item as ItemUsable] = usables.get(item, 0) + amount
	elif item is ItemPassive:
		passives[item as ItemPassive] = passives.get(item, 0) + amount
	elif item is ItemEquippable:
		equippables[item as ItemEquippable] = equippables.get(item, 0) + amount

func remove_item(item: Item, amount: int = 1):
	if item is ItemUsable:
		remove_from_dict(usables, item, amount)
	elif item is ItemPassive:
		remove_from_dict(passives, item, amount)
	elif item is ItemEquippable:
		remove_from_dict(equippables, item, amount)

func remove_from_dict(dict: Dictionary, item: Item, amount: int):
	if dict.has(item):
		dict[item] -= amount
		if dict[item] <= 0:
			dict.erase(item)
