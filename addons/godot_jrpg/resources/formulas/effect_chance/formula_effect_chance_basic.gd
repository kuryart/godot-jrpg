class_name FormulaEffectChanceBasic extends FormulaEffectChance

@warning_ignore("unused_parameter")
func calculate(param: FormulaEffectChanceParameter) -> float:
	var chance = param.defender.get_effect_dodge()
	return chance
