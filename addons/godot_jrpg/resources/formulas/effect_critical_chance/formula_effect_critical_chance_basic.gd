@abstract class_name FormulaEffectCriticalChanceBasic extends FormulaEffectCriticalChance

@warning_ignore("unused_parameter")
func calculate(param: FormulaEffectCriticalChanceParameter) -> float:
	var chance = param.defender.get_critical_dodge() / 100
	return chance
