class_name FormulaDamageRPGMaker extends FormulaDamage

func calculate(param: FormulaDamageParameter) -> int:
	var atk = param.attacker.stats.attack.get_value()
	var def = param.defender.stats.defense.get_value()
	var result = (4 * atk) - (2 * def)
	return max(1, result)
