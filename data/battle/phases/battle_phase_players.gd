class_name BattlePhasePlayers extends BattlePhase

func _init() -> void:
	resource_name = "Players"

func resolve(engine: BattleEngine):
	engine.battle_signals.update_enemy_focus_neighbor_emited.emit()
	engine.go_to_players_menu()
	print("[BattlePhasePlayers] CURRENT PLAYER: %s" % engine.current_player.data.name)
