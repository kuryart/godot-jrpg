class_name FormulaCriticalChancePokemon extends FormulaCriticalChance

func calculate(param: FormulaCriticalChanceParameter) -> float:
	var threshold = floor(param.attacker.stats.speed.get_value() / 2.0)
	if param.is_high_crit_move:
		threshold *= 8
	if param.has_focus_energy:
		threshold = floor(threshold / 4.0)
	threshold = min(threshold, 255)
	return threshold / 256.0
