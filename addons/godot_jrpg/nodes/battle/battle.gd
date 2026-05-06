## The main class for battle system. 
##
## It simply receives [BattleSettings] from a [CommandStartBattle]; await for 
## [InputManager] to setup; reference [BattleEngine] and [BattleUI] and initialize 
## the battle engine with battle settings and battle UI. 
class_name Battle extends Node

## Used to inform that the battle finished.
signal battle_finished

func _enter_tree() -> void:
	print("[Battle] Starting battle.")

## It receives [BattleSettings] from a [CommandStartBattle]; await for [InputManager] 
## to setup; reference [BattleEngine] and [BattleUI] and initialize the battle engine 
## with battle settings and battle UI. 
func initialize(settings: BattleSettings):
	await InputManager.input_setup_complete
	var engine: BattleEngine = $BattleEngine
	var ui: BattleUI = $BattleUI
	engine.initialize(settings, ui)
	engine.battle_signals.inner_battle_ended.connect(_on_inner_battle_ended)

func _on_inner_battle_ended():
	print("[Battle]: Battle finished.")
	battle_finished.emit()
