class_name BattlePhaseStart extends BattlePhase

func _init() -> void:
	resource_name = "Start"

func resolve(engine: BattleEngine):
	engine.change_turn()
	engine.battle_signals.toggle_menu_bottom_emited.emit(true)
	end()
