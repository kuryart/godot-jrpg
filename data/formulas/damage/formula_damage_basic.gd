class_name FormulaDamageBasic extends FormulaDamage

func calculate(param: FormulaDamageParameter) -> int:
	var atk = param.attacker.stats.attack.get_value()
	var def = param.defender.stats.defense.get_value()
	@warning_ignore("integer_division")
	var result = atk / def
	return max(1, result)
