class_name CurveStatGrowth extends StatGrowth

@export var curve: Curve
@export var max_value: int = 100

func calculate(param: FormulaStatGrowthParameter) -> int:
	var progress = float(param.level - 1) / 98.0
	return int(curve.sample(progress) * max_value)
