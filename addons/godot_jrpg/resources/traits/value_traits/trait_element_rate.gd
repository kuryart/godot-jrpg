## This trait defines how much damage is taken from a specific element.
class_name TraitElementRate extends TraitValue

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
func calculate(target_element: Element, damage: float) -> float:
	if target_element == element:
		return damage * rate
	
	return damage
