## This trait defines how much damage is received by the battler (multiplier).
class_name TraitDamageReceived extends TraitValue

## Damage multiplier: 
## 1.0 = Normal (100%)
## 0.5 = Resistance (50%)
## 2.0 = Weakness (200%)
## 0.0 = No damage (0%)
@export var rate: float = 1.0

func _init() -> void:
	type = TYPE.DAMAGE_RECEIVED

func _to_string() -> String:
	return "[Trait:DAMAGE RECEIVED MULTIPLIER | %s]" % rate
