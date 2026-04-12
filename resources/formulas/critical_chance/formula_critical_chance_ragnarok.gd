class_name FormulaCriticalChanceRagnarok extends FormulaCriticalChance

func calculate(param: FormulaCriticalChanceParameter) -> float:
	var attacker_luck = param.attacker.stats.luck.get_value()
	var attacker_level = param.attacker.level
	var defender_luck = param.defender.stats.luck.get_value()
	var multiplier = param.attacker_luck_multiplier
	var divider = param.defender_luck_divider
	
	var attacker_chance = (attacker_luck * multiplier) / attacker_level
	var defender_resist = defender_luck / divider
	var chance = attacker_chance - defender_resist
	
	return clamp(chance, 0.0, 100.0) / 100.0
