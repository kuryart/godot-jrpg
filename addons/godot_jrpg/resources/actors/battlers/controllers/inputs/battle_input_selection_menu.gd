class_name BattleInputSelectionMenu extends BattleInput

func resolve(engine: BattleEngine) -> void:
	engine.current_phase.end()
	await engine.change_phase(BattlePhaseSelection.new())
