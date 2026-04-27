class_name TraitAggregator extends Resource

## Godot don't allows nested typed collection, but the right signature is 
## Dictionary[Trait.TYPE, Array[Traits]].
var traits_by_type: Dictionary = {}
var stat_multipliers: Dictionary = {}
var stat_sums: Dictionary = {}
var damage_dealt_multipliers: Dictionary = {}
var damage_dealt_sums: Dictionary = {}
var damage_received_multipliers: Dictionary = {}
var damage_received_sums: Dictionary = {}
var flags: Dictionary = {}
var battler: Battler
var sources: Array[TraitList] = []

func _init(_battler: Battler) -> void:
	battler = _battler
	clear_cache()

func refresh():
	clear_cache()
	traits_by_type = collect_and_sort_traits()
	stat_calc()
	damage_dealt_calc()
	damage_received_calc()

func clear_cache() -> void:
	traits_by_type.clear()
	stat_multipliers.clear()
	stat_sums.clear()
	damage_dealt_multipliers.clear()
	damage_dealt_sums.clear()
	damage_received_multipliers.clear()
	damage_received_sums.clear()
	flags.clear()
	for type_key in Trait.TYPE.values():
		traits_by_type[type_key] = []

func collect_and_sort_traits() -> Dictionary:
	var sorted_traits: Dictionary = {}
	for type_key in Trait.TYPE.values():
		sorted_traits[type_key] = []
	prepare_sources()
	for list in sources:
		if list == null: 
			continue
		for t in list.entries:
			sorted_traits[t.type].append(t)
				
	return sorted_traits

func prepare_sources() -> void:
	if battler is Player:
		sources = [
			battler.player_class.traits,
			battler.player_class.slots.weapon.item.traits,
			battler.player_class.slots.armor.item.traits,
			battler.player_class.slots.accessory.item.traits,
			battler.player_class.slots.head.item.traits,
			battler.player_class.slots.shield.item.traits
		]
	sources.append(battler.traits)
	for s in battler.status:
		sources.append(s.traits)

func stat_calc() -> void:
	var list = traits_by_type.get(Trait.TYPE.STAT)
	for _trait in list:
		if _trait is TraitStat:
			var stat_name = _trait.stat_name
			var current_multiplier = stat_multipliers.get(stat_name, 1.0)
			var current_sum = stat_sums.get(stat_name, 0)
			stat_multipliers[stat_name] = current_multiplier * _trait.value_multiply
			stat_sums[stat_name] = current_sum + _trait.value_add
			
func damage_dealt_calc() -> void:
	var list = traits_by_type.get(Trait.TYPE.DAMAGE_DEALT, [])
	for _trait in list:
		var type = _trait.damage_type
		var current_mult = damage_dealt_multipliers.get(type, 1.0)
		var current_sum = damage_dealt_sums.get(type, 0.0)
		damage_dealt_multipliers[type] = current_mult * _trait.value_multiply
		damage_dealt_sums[type] = current_sum + _trait.value_add

func damage_received_calc() -> void:
	var list = traits_by_type.get(Trait.TYPE.DAMAGE_RECEIVED, [])
	for _trait in list:
		var type = _trait.damage_type
		var current_mult = damage_received_multipliers.get(type, 1.0)
		var current_sum = damage_received_sums.get(type, 0.0)
		damage_received_multipliers[type] = current_mult * _trait.value_multiply
		damage_received_sums[type] = current_sum + _trait.value_add

#---------------
#--- FACADES ---
#---------------
func get_stat_modified(stat_name: StringName, base_value: float) -> float:
	var sum = stat_sums.get(stat_name, 0.0)
	var mult = stat_multipliers.get(stat_name, 1.0)
	return (base_value + sum) * mult

func get_damage_dealt_modified(type: StringName, base_damage: float) -> float:
	var sum = damage_dealt_sums.get(type, 0.0)
	var mult = damage_dealt_multipliers.get(type, 1.0)
	return (base_damage + sum) * mult

func get_damage_received_modified(type: StringName, base_damage: float) -> float:
	var sum = damage_received_sums.get(type, 0.0)
	var mult = damage_received_multipliers.get(type, 1.0)
	return (base_damage + sum) * mult
