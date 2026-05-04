class_name Stat extends Resource

@export var display_name: String = "Stat"
@export var id: ID
@export var base_value: int = 0:
	set(v):
		base_value = v
		is_dirty = true
enum ID {
	HP, MP, ATTACK, DEFENSE, INTELLIGENCE, SPEED, ACCURACY, EVASION,
	LUCK, HP_REGEN, MP_REGEN, CRITICAL, CRITICAL_DODGE, MAGICAL_DODGE,
	REFLECTION, COUNTER_ATTACK
}

var level_growth_value: int = 0:
	set(v):
		level_growth_value = v
		is_dirty = true
var modifiers: Array[StatModifier] = []
var cached_value: int = 0
var is_dirty: bool = true

func get_value() -> int:
	if is_dirty:
		cached_value = calculate_final_value()
		is_dirty = false
	return cached_value

func calculate_final_value() -> int:
	var total_add = 0.0
	var total_mult = 1.0
	
	for mod in modifiers:
		total_add += mod.value_add
		total_mult *= mod.value_multiply
	var core_value = base_value + level_growth_value
	return int(max(0, (core_value + total_add) * total_mult))

func remove_modifier(mod: StatModifier):
	if modifiers.has(mod):
		modifiers.erase(mod)
		is_dirty = true

func remove_modifiers_by_name(mod_name: String):
	var to_remove = modifiers.filter(func(m): return m.name == mod_name)
	for m in to_remove:
		modifiers.erase(m)
	is_dirty = true

## Remove old modifiers with same ID to avoid stacking.
func add_modifier(mod: StatModifier):
	if mod.id != &"":
		remove_modifiers_by_id(mod.id)
	modifiers.append(mod)
	is_dirty = true

func remove_modifiers_by_id(target_id: StringName):
	var initial_count = modifiers.size()
	modifiers = modifiers.filter(func(m): return m.id != target_id)
	if modifiers.size() != initial_count:
		is_dirty = true
