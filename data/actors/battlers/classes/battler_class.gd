## The class for... classes! I mean, character classes.
## It have some [StatGrowth] variables, so the progression for a stat is defined here.
class_name PlayerClass extends Resource

## The class name.
@export var name: String
## The class description.
@export_multiline var description: String

@export_group("Growth Methods")
## The progression by level for hp.
@export var hp_growth: StatGrowth
## The progression by level for mp.
@export var mp_growth: StatGrowth
## The progression by level for attack.
@export var attack_growth: StatGrowth
## The progression by level for defense.
@export var defense_growth: StatGrowth
## The progression by level for intelligence.
@export var intelligence_growth: StatGrowth
## The progression by level for speed.
@export var speed_growth: StatGrowth
## The progression by level for accuracy.
@export var accuracy_growth: StatGrowth
## The progression by level for evasion.
@export var evasion_growth: StatGrowth
## The progression by level for luck.
@export var luck_growth: StatGrowth
