class_name CurveStatGrowth extends StatGrowth

@export var curve: Curve
@export var max_growth_value: int = 999
@export var max_level: int = 99

func calculate(param: FormulaStatGrowthParameter) -> int:
	var ratio = float(param.level - 1) / float(max_level - 1)
	var curve_sample = curve.sample(ratio)
	return int(curve_sample * max_growth_value)
