class_name BattlePlayerUI extends BattleBattlerUI

var engine: BattleEngine
var player: Player

func setup(_engine: BattleEngine, _player: Player):
	engine = _engine
	player = _player

func _on_button_up():
	super()
	engine.battle_signals.player_selected.emit()
