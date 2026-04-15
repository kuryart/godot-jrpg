class_name BattleInputFightMenu extends BattleInput

func resolve(engine: BattleEngine):
	engine.current_phase.end()
	var fight_phase: BattlePhaseFight = BattlePhaseFight.new()
	fight_phase.set_player(engine.current_player)
	await engine.change_phase(fight_phase)
