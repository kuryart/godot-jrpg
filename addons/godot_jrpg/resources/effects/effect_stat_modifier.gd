## Any effect which changes a [Stat] value should use this class.
class_name EffectStatModifier extends Effect

## The name for the stat. It must be equal to the name you used in the .tres resource
## file. By default, the stats names are: HP, MP, Attack, Defense, Intelligence, Speed,
## Accuracy, Evasion and Luck.
@export var stat_name: String = "Attack"
## The unique ID for the effect, used to know which buff is the one we are looking for.
@export var effect_id: StringName = &"buff_attack"
## The value if there is a multiplication.
@export var value_multiply: float = 1.0
## The value if there is a sum.
@export var value_add: int = 0
## The duration of the effect.
@export var duration: int = -1

## Apply the effect.
func apply(target: Battler):
	var stat_obj = target.stats.get_stat_by_name(stat_name)
	if stat_obj:
		var mod = StatModifier.new(effect_id, value_multiply, value_add, duration)
		stat_obj.add_modifier(mod)
