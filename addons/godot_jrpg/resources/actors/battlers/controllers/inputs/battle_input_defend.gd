class_name BattleInputDefend extends BattleInput

func resolve(engine: BattleEngine):
	var action = BattleActionDefend.new()
	action.actor = engine.current_player
	engine.action_pool.append(action)
	engine.change_to_next_player()
	await engine.change_phase(BattlePhasePlayers.new())
