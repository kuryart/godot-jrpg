class_name FormulaHitChanceSigmoid extends FormulaHitChance

func calculate(param: FormulaHitChanceParameter) -> float:
	var diff = param.attacker.stats.accuracy.get_value() - param.attacker.stats.evasion.get_value()
	return 1.0 / (1.0 + exp(-0.1 * diff))
