class_name FormulaSkillDamageRPGMaker extends FormulaSkillDamage

@export var base_damage: int

func calculate(param: FormulaSkillDamageParameter) -> int:
	var atk = param.attacker.stats.intelligence.get_value()
	var def = param.defender.stats.intelligence.get_value()
	var result = base_damage + (4 * atk) - (2 * def)
	return max(1, result)
