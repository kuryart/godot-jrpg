class_name BattlePhaseAttack extends BattlePhase

func _init() -> void:
	resource_name = "Attack"

func resolve(engine: BattleEngine):
	engine.select_enemy()
