class_name FormulaXPPokemon extends FormulaXP

func calculate(param: FormulaXPParameter):
	return int((4.0 * pow(float(param.level), 3.0)) / 5.0)
