class_name FormulaCriticalChanceParameter extends FormulaParameter

var attacker: Battler
var defender: Battler

# Pokemon
var is_high_crit_move: bool
var has_focus_energy: bool

# Pokemon New Gen
var stage: int = 0

# Ragnarok
var attacker_luck_multiplier: float = 0.3
var defender_luck_divider: float = 5.0
