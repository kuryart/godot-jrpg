class_name BattlePhaseCleanup extends BattlePhase

func _init() -> void:
	resource_name = "Cleanup"

func resolve(engine: BattleEngine):
	engine.resolve_post_effects()
