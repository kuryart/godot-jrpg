## This trait defines how much damage is taken from a specific element.
class_name TraitElementRateDefend extends TraitValue

## Reference to your custom Element Resource (e.g., Fire.tres, Ice.tres)
@export var element: Element
## Damage multiplier: 
## 1.0 = Normal (100%)
## 0.5 = Resistance (50%)
## 2.0 = Weakness (200%)
## 0.0 = Immunity (0%)
@export var multiplier: float = 1.0
## This is added or subtracted from the defense.
@export var sum: int = 0

func _init() -> void:
	type = TYPE.DAMAGE_RECEIVED

func _to_string() -> String:
	var element_name = element.name if element else "None"
	return "[Trait:RESISTANCE | %s x%.2f +%d]" % [element_name, multiplier, sum]
