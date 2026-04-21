class_name TraitAggregator extends Resource

var owner: Battler
var sources: Array[TraitList] = []

func _init(_owner: Battler) -> void:
	owner = _owner

func collect_and_sort_traits() -> Dictionary:
	var sorted_traits: Dictionary = {}
	for type_key in Trait.TYPE.values():
		sorted_traits[type_key] = []
	
	prepare_sources()
	
	for list in sources:
		for t in list.entries:
			sorted_traits[t.type].append(t)
				
	return sorted_traits

func prepare_sources() -> void:
	if owner is Player:
		sources = [
			owner.traits,
			owner.player_class.traits,
			owner.player_class.slots.weapon.traits,
			owner.player_class.slots.armor.traits,
			owner.player_class.slots.accessory.traits,
			owner.player_class.slots.head.traits,
			owner.player_class.slots.shield.traits
		]
	elif owner is Enemy:
		sources = [owner.traits]
