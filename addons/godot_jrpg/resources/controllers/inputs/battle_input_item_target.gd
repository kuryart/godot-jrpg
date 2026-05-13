class_name BattleInputItemTarget extends BattleInput

func resolve(engine: BattleEngine):
	engine.battle_signals.toggle_menu_items_emited.emit(false)
	engine.current_phase.end()
	await engine.change_phase(BattlePhaseItemTarget.new())
