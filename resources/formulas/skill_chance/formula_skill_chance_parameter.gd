class_name FormulaSkillChanceParameter extends FormulaParameter

@export_range(0.0, 100.0) var min_chance: float = 5.0
@export_range(0.0, 100.0) var max_chance: float = 95.0

var attacker: Battler
var defender: Battler

var base_chance: float = 50.0
