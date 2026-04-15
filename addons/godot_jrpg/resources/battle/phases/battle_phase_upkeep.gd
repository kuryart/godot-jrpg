class_name BattlePhaseUpkeep extends BattlePhase

func _init() -> void:
	resource_name = "Upkeep"

func resolve(engine: BattleEngine):
	#engine.resolve_pre_effects()
	engine.resolve_battle()
