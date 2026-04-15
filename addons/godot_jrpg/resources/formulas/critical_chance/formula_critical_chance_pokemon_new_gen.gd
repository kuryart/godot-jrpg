class_name FormulaCriticalChancePokemonNewGen extends FormulaCriticalChance

var stage_0_chance: float = 4.17
var stage_1_chance: float = 12.5
var stage_2_chance: float = 50.0
var stage_3_chance: float = 100.0

func calculate(param: FormulaCriticalChanceParameter) -> float:
	if param.stage == 0: return stage_0_chance / 100
	if param.stage == 1: return stage_1_chance / 100
	if param.stage == 2: return stage_2_chance / 100
	if param.stage >= 3: return stage_3_chance / 100
	
	return 0.0
