class_name BattlePhaseItemSelect extends BattlePhase

func _init() -> void:
	resource_name = "ItemSelect"

func resolve(engine: BattleEngine):
	engine.battle_signals.toggle_menu_items_emitted.emit(true)

func handle_cancel(engine: BattleEngine):
	BattleInputFightMenu.new().resolve(engine)
