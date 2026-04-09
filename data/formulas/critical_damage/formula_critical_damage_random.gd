class_name FormulaCriticalDamageRandom extends FormulaCriticalDamage

func calculate(param: FormulaCriticalDamageParameter) -> float:
	return randf_range(param.min_value, param.max_value)
