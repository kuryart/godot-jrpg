class_name FormulaHitChanceProportion extends FormulaHitChance

func calculate(param: FormulaHitChanceParameter) -> float:
	var accuracy = param.attacker.stats.accuracy
	var evasion = param.defender.stats.evasion
	var base_chance = param.base_chance
	return (base_chance * accuracy) / max(evasion, 1)
