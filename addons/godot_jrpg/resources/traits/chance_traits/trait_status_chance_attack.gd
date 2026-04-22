class_name TraitStatusChanceAttack extends TraitChance

@export_range(0.0,100.0,1) var chance: float
@export var status: Status

func apply() -> float:
	return chance
