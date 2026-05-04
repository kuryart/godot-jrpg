class_name BattlePhaseUpkeep extends BattlePhase

func _init() -> void:
	resource_name = "Upkeep"

func resolve(engine: BattleEngine):
	#engine.resolve_upkeep_effects()
	engine.resolve_battle()
