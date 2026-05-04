## Handles Page 2: Parameter Settings - Normal Parameters
## This trait defines multiplicative modifiers for core actor/enemy stats.
class_name TraitStat extends TraitValue

## The core statistic to be modified.
@export var stat: Stat
## The multiplier applied to the base parameter.
## 1.0 = 100% (No change)
## 1.2 = 120% (20% bonus)
## 0.8 = 80% (20% penalty)
@export var value_multiply: float = 1.0
@export var value_add: int = 0

func _init() -> void:
	type = TYPE.STAT

#func _to_string() -> String:
	#return "[Trait:STAT | %s x%.2f +%d]" % [stat.display_name, value_multiply, value_add]
