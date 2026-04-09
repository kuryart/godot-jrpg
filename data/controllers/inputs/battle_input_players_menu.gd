class_name BattleInputPlayersMenu extends BattleInput

func resolve(engine: BattleEngine):
	engine.current_phase.end()
	await engine.change_phase(BattlePhasePlayers.new())
