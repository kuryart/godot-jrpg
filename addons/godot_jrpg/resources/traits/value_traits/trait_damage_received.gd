## This trait defines how much damage is received by the battler (multiplier).
class_name TraitDamageReceived extends TraitValue

## Damage multiplier: 
## 1.0 = Normal (100%)
## 0.5 = Resistance (50%)
## 2.0 = Weakness (200%)
## 0.0 = No damage (0%)
@export var multiplier: float = 1.0
## Damage amount to be sum
@export var sum: int = 0

func _to_string() -> String:
	return "[Trait:DAMAGE RECEIVED | Multiplier %s, Sum %s]" % [multiplier, sum]
