## This trait defines how much damage is dealt by the battler (multiplier).
class_name TraitEffectDamageDealt extends TraitValue

## Damage multiplier: 
## 1.0 = Normal (100%)
## 0.5 = Weak (50%)
## 2.0 = Strong (200%)
## 0.0 = No damage (0%)
@export var multiplier: float = 1.0
## Damage amount to be sum
@export var sum: int = 0

func _to_string() -> String:
	return "[Trait:DAMAGE DEALT | Multiplier %s, Sum %s]" % [multiplier, sum]
