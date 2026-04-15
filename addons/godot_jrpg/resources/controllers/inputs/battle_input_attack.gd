class_name BattleInputAttack extends BattleInput

func resolve(engine: BattleEngine):
	engine.current_phase.end()
	await engine.change_phase(BattlePhaseAttack.new())
