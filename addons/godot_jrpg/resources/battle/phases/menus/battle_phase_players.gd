class_name BattlePhasePlayers extends BattlePhase

func _init() -> void:
	resource_name = "Players"

func resolve(engine: BattleEngine):
	engine.battle_signals.update_enemy_focus_neighbor_emitted.emit()
	engine.go_to_players_menu()
	print("[BattlePhasePlayers] CURRENT PLAYER: %s" % engine.current_player.name)

func handle_cancel(engine: BattleEngine):
	if engine.current_player == engine.get_first_alive_player():
		BattleInputSelectionMenu.new().resolve(engine)
	else:
		var previous_player = engine.get_previous_player()
		engine.remove_player_action(previous_player)
		engine.change_to_player(previous_player)
		#BattleInputFightMenu.new().resolve(engine)
