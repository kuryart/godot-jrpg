class_name FormulaEffectCriticalDamageRandom extends FormulaEffectCriticalDamage

func calculate(param: FormulaEffectCriticalDamageParameter) -> int:
	return randf_range(param.min_value, param.max_value)
