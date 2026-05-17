class_name BattlePhaseUpkeep extends BattlePhase

var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

func _init() -> void:
	resource_name = "Upkeep"

func resolve(engine: BattleEngine):
	print("[BattlePhaseUpkeep] Processing upkeep...")
	engine.process_status_duration()
	battle_signals.status_refreshed.emit(engine)
	await engine.validate_deaths()
	if engine.check_battle_end(): return
	end()
	engine.change_turn()
	engine.change_phase(BattlePhaseSelection.new())
