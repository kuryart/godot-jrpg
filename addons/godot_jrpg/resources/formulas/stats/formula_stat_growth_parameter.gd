class_name FormulaStatGrowthParameter extends FormulaParameter

# Base stats
var level: int
var base_stat_value: int

# Pokémon
var is_hp: bool = false
var dv: int = 0 # 0 to 15 - Genetic, unique value for an individual pokémon
var stat_exp: int = 0 # 0 to 65535 - Effort, training, obtained by defeating pokémons
