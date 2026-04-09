class_name Stat extends Resource

@export var base_value: int = 0:
	set(v):
		base_value = v
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
		if mod.type == StatModifier.Type.ADDITIVE:
			total_add += mod.value
		else:
			total_mult *= mod.value
			
	return int(max(0, (base_value + total_add) * total_mult))

func add_modifier(mod: StatModifier):
	if not modifiers.has(mod):
		modifiers.append(mod)
		is_dirty = true

func remove_modifier(mod: StatModifier):
	if modifiers.has(mod):
		modifiers.erase(mod)
		is_dirty = true

func remove_modifiers_by_name(mod_name: String):
	var to_remove = modifiers.filter(func(m): return m.name == mod_name)
	for m in to_remove:
		modifiers.erase(m)
	is_dirty = true
