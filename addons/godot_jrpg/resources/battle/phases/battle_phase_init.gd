class_name BattlePhaseInit extends BattlePhase

func _init() -> void:
	resource_name = "Init"

func resolve(engine: BattleEngine):
	setup_players(engine)
	define_leader(engine)
	setup_enemies(engine)
	setup_ui(engine)
	set_background(engine)
	instantiate_enemies(engine)
	define_focus_neighbors(engine.battle_ui)
	instantiate_players(engine)
	hide_menus(engine.battle_ui)
	drop_enemies_focus(engine.battle_ui)
	connect_signals(engine)
	for i in range(engine.battlers.size()):
		print("[BattlePhaseInit] Battle Actors: ", engine.battlers[i].name)
	end()

func setup_players(engine: BattleEngine) -> void:
	var handlers_root = engine.get_node("../BattleInputHandlers")
	
	for i in range(engine.battle_settings.party.players.size()):
		var player: Player = engine.battle_settings.party.players[i]
		var ctrl = player.controller

		if ctrl is PlayerManualController:
			ctrl.input_assignment = InputManager.get_assignment(i)
			
			var handler = BattleInputHandler.new(ctrl.input_assignment)
			handler.name = "P%d_Handler" % (i + 1)
			handlers_root.add_child(handler)
			
			ctrl.setup(engine, handler, player)
		elif ctrl is PlayerNPCController:
			ctrl.setup(engine, null, null)
			
		engine.add_battle_battler(player)
	
	for i in range(engine.players.size()):
		print("[BattlePhaseInit] Players: ", engine.players[i].name)

func define_leader(engine: BattleEngine) -> void:
	engine.leader = engine.players[0]

func setup_enemies(engine: BattleEngine) -> void:
	for i in range(engine.battle_settings.enemies.size()):
		var enemy: Enemy = engine.battle_settings.enemies[i].enemy.duplicate()
		var ctrl: EnemyController = enemy.controller
		ctrl.setup(engine, null, null)
		engine.add_battle_battler(enemy)

	for i in range(engine.enemies.size()):
		print("[BattlePhaseInit] Enemies: ", engine.enemies[i].name)

func setup_ui(engine: BattleEngine):
	if not engine.visuals_enabled: return
	
	engine.battle_ui.setup_ui()

func set_background(engine: BattleEngine):
	var settings: BattleSettings = engine.battle_settings
	var ui: BattleUI = engine.battle_ui
	ui.battle_signals.set_background_emited.emit(settings)

func instantiate_enemies(engine: BattleEngine):
	var enemies_settings: Array[EnemySettings] = engine.battle_settings.enemies
	var enemies: Array[Enemy] = engine.enemies
	var ui: BattleUI = engine.battle_ui
	ui.battle_signals.instantiate_enemies_emited.emit(enemies_settings, enemies, engine)

func define_focus_neighbors(ui: BattleUI):
	ui.battle_signals.define_focus_neighbors_emited.emit()

func instantiate_players(engine: BattleEngine):
	var players: Array[Player] = engine.players
	var ui: BattleUI = engine.battle_ui
	ui.battle_signals.instantiate_players_emited.emit(engine, players)

func hide_menus(ui: BattleUI):
	ui.battle_signals.toggle_menu_bottom_emited.emit(false)
	ui.battle_signals.toggle_menu_items_emited.emit(false)
	ui.battle_signals.toggle_menu_skills_emited.emit(false)

func drop_enemies_focus(ui: BattleUI):
	ui.battle_signals.enemies_focus_mode_changed.emit(Control.FOCUS_NONE)

func connect_signals(engine: BattleEngine):
	engine.battle_signals.enemy_selected.connect(engine._on_enemy_selected)
