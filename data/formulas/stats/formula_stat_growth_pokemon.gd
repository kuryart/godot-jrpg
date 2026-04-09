class_name FormulaStatGrowthPokemon extends StatGrowth

func calculate(param: FormulaStatGrowthParameter) -> int:
	var exp_bonus = floor(sqrt(param.stat_exp) / 4.0)
	var main_calc = floor(((param.base_stat_value + param.dv) * 2 + exp_bonus) * param.level / 100.0)
	
	if param.is_hp:
		return int(main_calc + param.level + 10)
	return int(main_calc + 5)
