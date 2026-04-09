class_name BattlePlayerUI extends BattleBattlerUI

var engine: BattleEngine
var battle_player: BattlePlayer

func setup(_engine: BattleEngine, _battle_player: BattlePlayer):
	engine = _engine
	battle_player = _battle_player

func _on_button_up():
	super()
	engine.battle_signals.player_selected.emit()
