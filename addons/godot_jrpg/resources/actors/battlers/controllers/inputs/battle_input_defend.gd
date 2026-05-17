class_name BattleInputDefend extends BattleInput

func resolve(engine: BattleEngine):
	var action = BattleActionDefend.new()
	action.actor = engine.current_player
	engine.action_pool.append(action)
	engine.change_to_next_player()
	if engine.current_phase is BattlePhaseResolveActions:
		return
	await engine.change_phase(BattlePhasePlayers.new())
