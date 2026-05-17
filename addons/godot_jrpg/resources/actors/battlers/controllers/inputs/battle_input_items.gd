class_name BattleInputItems extends BattleInput

func resolve(engine: BattleEngine):
	engine.current_phase.end()
	await engine.change_phase(BattlePhaseItemSelect.new())
