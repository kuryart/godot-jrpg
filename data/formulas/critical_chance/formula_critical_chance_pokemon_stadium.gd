class_name FormulaCriticalChancePokemonStadium extends FormulaCriticalChance

func calculate(param: FormulaCriticalChanceParameter) -> float:
	var threshold: float
	var base_t = floor((param.attacker.stats.speed.get_value() + 76.0) / 4.0)
	
	if param.has_focus_energy:
		if param.is_high_crit_move:
			threshold = 255.0
		else:
			threshold = floor((param.attacker.stats.speed.get_value() + 236.0) / 64.0) * 2
	else:
		threshold = base_t
		if param.is_high_crit_move:
			threshold *= 8
			
	threshold = min(threshold, 255.0)
	
	return threshold / 256.0
