class_name TestBattle extends Node

@warning_ignore("unused_signal")
signal battle_finished

func _enter_tree() -> void:
	print("[Battle] Starting test.")

func initialize(settings: BattleSettings):
	await InputManager.input_setup_complete
	var engine: BattleEngine = $BattleEngine
	var ui: BattleUI = $BattleUI
	engine.initialize(settings, ui)
