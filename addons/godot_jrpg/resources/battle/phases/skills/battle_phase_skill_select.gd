class_name BattlePhaseSkillSelect extends BattlePhase

func _init() -> void:
	resource_name = "SkillSelect"

func resolve(engine: BattleEngine):
	engine.battle_signals.toggle_menu_skills_emitted.emit(true)

func handle_cancel(engine: BattleEngine):
	BattleInputFightMenu.new().resolve(engine)
