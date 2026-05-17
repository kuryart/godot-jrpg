class_name BattlePhaseAttackTarget extends BattlePhase

func _init() -> void:
	resource_name = "Attack"

func resolve(engine: BattleEngine):
	engine.select_enemy()

func handle_cancel(engine: BattleEngine):
	BattleInputFightMenu.new().resolve(engine)
