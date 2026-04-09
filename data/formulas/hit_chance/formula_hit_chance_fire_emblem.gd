class_name FormulaHitChanceFireEmblem extends FormulaHitChance

func calculate(param: FormulaHitChanceParameter) -> float:
	var accuracy = param.attacker.stats.accuracy
	var evasion = param.defender.stats.evasion
	return clamp(accuracy - evasion, param.min_chance, param.max_chance) / 100
