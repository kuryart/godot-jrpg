class_name FormulaXPPokemon extends FormulaXP

func calculate(param: FormulaXPParameter):
	return (4 * pow(param.level, 3)) / 5
