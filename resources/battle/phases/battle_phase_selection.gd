class_name BattlePhaseSelection extends BattlePhase

func _init() -> void:
	resource_name = "Selection"

func resolve(engine: BattleEngine):
	engine.go_to_selection_menu()
