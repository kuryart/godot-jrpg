class_name FormulaEffectCriticalDamageBasic extends FormulaEffectCriticalDamage

@export var base_damage: int

func calculate(param: FormulaEffectCriticalDamageParameter) -> int:
	return param.multiplier
