@abstract class_name Effect extends Resource

@export var damage_formula: FormulaEffectDamage
@export var chance_formula: FormulaEffectChance
@export var critical_chance_formula: FormulaEffectCriticalChance
@export var elements: Array[Element]
@export var is_critical: bool = false

@warning_ignore("unused_parameter")
func apply(target: Battler):
	pass
