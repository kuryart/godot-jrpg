## This trait defines how much damage is taken from a specific element.
class_name TraitElementRateDefend extends TraitValue

## Reference to your custom Element Resource (e.g., Fire.tres, Ice.tres)
@export var element: Element
## Damage multiplier: 
## 1.0 = Normal (100%)
## 0.5 = Resistance (50%)
## 2.0 = Weakness (200%)
## 0.0 = Immunity (0%)
@export var rate: float = 1.0

func _init() -> void:
	type = TYPE.DAMAGE_RECEIVED

## Proccess the element rate if the element is the same.
func apply(target_element: Element, damage: float) -> float:
	if target_element == element:
		return damage * rate
	
	return damage

func _to_string() -> String:
	var element_name = element.name if element else "None"
	return "[Trait:RESISTANCE | %s x%.2f]" % [element_name, rate]
