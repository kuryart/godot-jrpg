class_name FormulaSkillDamageRPGMaker extends FormulaSkillDamage

func calculate(param: FormulaSkillDamageParameter) -> int:
	var atk = param.attacker.stats.intelligence.get_value()
	var def = param.defender.stats.intelligence.get_value()
	var result = param.base_damage + (4 * atk) - (2 * def)
	return max(1, result)
