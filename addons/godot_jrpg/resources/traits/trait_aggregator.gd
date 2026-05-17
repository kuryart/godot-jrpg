class_name TraitAggregator extends Resource

# --- All traits list
var all_traits: TraitList = TraitList.new()
var battler: Battler
var sources: Array[TraitList] = []

func _init(_battler: Battler) -> void:
	battler = _battler
	clear_cache()

func refresh():
	clear_cache()
	collect_traits()

func clear_cache() -> void:
	all_traits.entries.clear()
	sources.clear()

func collect_traits():
	get_sources()
	for source: TraitList in sources:
		if source == null: 
			continue
		for _trait in source.entries:
			all_traits.entries.append(_trait)

func get_sources():
	if battler is Player:
		if battler.player_class.traits:
			sources.append(battler.player_class.traits)
		if battler.equip.weapon.item:
			sources.append(battler.equip.weapon.item.traits)
		if battler.equip.armor.item:
			sources.append(battler.equip.armor.item.traits)
		if battler.equip.accessory.item:
			sources.append(battler.equip.accessory.item.traits)
		if battler.equip.head.item:
			sources.append(battler.equip.head.item.traits)
		if battler.equip.shield.item:
			sources.append(battler.equip.shield.item.traits)
	if battler.traits:
		sources.append(battler.traits)
	for s in battler.status:
		if s.traits:
			sources.append(s.traits)

#---------------
#--- FACADES ---
#---------------
func get_stat_modified(target_stat_id: Stat.ID, base_value: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitStat:
			if _trait.stat.id == target_stat_id:
				sum += _trait.sum
				mult *= _trait.multiplier
				
	return int((base_value + sum) * mult)

func get_elemental_damage_dealt_modified(target_element: Element, base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitElementDamageDealt:
			if _trait.element.name == target_element.name:
				sum += _trait.sum
				mult *= _trait.multiplier
				
	return max(int((base_damage + sum) * mult), 1)

func get_elemental_damage_received_modified(target_element: Element, base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitElementDamageReceived:
			if _trait.element.name == target_element.name:
				sum += _trait.sum
				mult *= _trait.multiplier
				
	return max(int((base_damage - sum) * mult), 1)

func get_damage_dealt_modified(base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitDamageDealt:
			sum += _trait.sum
			mult *= _trait.multiplier
				
	return max(int((base_damage + sum) * mult), 1)

func get_damage_received_modified(base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitDamageReceived:
			sum += _trait.sum
			mult *= _trait.multiplier

	return max(int((base_damage - sum) * mult), 1)

func get_status_chance_on_attack() -> Dictionary[Status, float]:
	var status_with_chance: Dictionary[Status, float] = {}
	
	for _trait in all_traits.entries:
		if _trait is TraitStatusChanceAttack:
			var current_highest = status_with_chance.get(_trait.status, 0.0)
			if _trait.chance > current_highest:
				status_with_chance[_trait.status] = _trait.chance
				
	return status_with_chance

func get_status_chance_on_defend() -> Dictionary[Status, float]:
	var status_with_chance: Dictionary[Status, float] = {}
	
	for _trait in all_traits.entries:
		if _trait is TraitStatusChanceDefend:
			var current_highest = status_with_chance.get(_trait.status, 0.0)
			if _trait.chance > current_highest:
				status_with_chance[_trait.status] = _trait.chance
				
	return status_with_chance

func get_effect_elemental_damage_dealt_modified(target_element: Element, base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitEffectElementDamageDealt:
			if _trait.element.name == target_element.name:
				sum += _trait.sum
				mult *= _trait.multiplier
				
	return max(int((base_damage + sum) * mult), 1)

func get_effect_elemental_damage_received_modified(target_element: Element, base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitEffectElementDamageReceived:
			if _trait.element.name == target_element.name:
				sum += _trait.sum
				mult *= _trait.multiplier
				
	return max(int((base_damage - sum) * mult), 1)

func get_effect_damage_dealt_modified(base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitEffectDamageDealt:
			sum += _trait.sum
			mult *= _trait.multiplier
				
	return max(int((base_damage + sum) * mult), 1)

func get_effect_damage_received_modified(base_damage: float) -> int:
	var sum: int = 0
	var mult: float = 1.0
	
	for _trait in all_traits.entries:
		if _trait is TraitEffectDamageReceived:
			sum += _trait.sum
			mult *= _trait.multiplier

	return max(int((base_damage - sum) * mult), 1)

func has_trait_no_xp() -> bool:
	for _trait in all_traits.entries:
		if _trait is TraitNoXp:
			return true
	return false
