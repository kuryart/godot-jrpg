## This trait defines how much damage is dealt by the battler (multiplier).
class_name TraitDamageDealt extends TraitValue

## Damage multiplier: 
## 1.0 = Normal (100%)
## 0.5 = Weak (50%)
## 2.0 = Strong (200%)
## 0.0 = No damage (0%)
@export var rate: float = 1.0

func _init() -> void:
	type = TYPE.DAMAGE_DEALT

func _to_string() -> String:
	return "[Trait:DAMAGE DEALT MULTIPLIER | %s]" % rate
