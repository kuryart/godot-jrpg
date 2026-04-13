class_name BattleSignals extends Resource

@warning_ignore_start("unused_signal")
# --- Background ---
signal set_background_emited(settings: BattleSettings)
# --- Actors ---
signal instantiate_enemies_emited(enemies_settings: Array[EnemySettings], enemies: Array[Enemy], engine: BattleEngine)
signal instantiate_players_emited(engine: BattleEngine, players: Array[Player])
signal player_selected
signal select_enemy_emited
signal battler_damaged(battler: Battler)
signal player_changed(player: Player)
signal enemy_selected
signal damage_finished
signal change_player_face_emited(action: BattleAction)
# --- Focus ---
signal define_focus_neighbors_emited
signal select_menu_selection_option_emited(id: int)
signal request_player_focus_emited(player: Player)
signal select_menu_fight_option_emited(id: int)
signal update_enemy_focus_neighbor_emited
signal enemies_focus_mode_changed(mode: Control.FocusMode)
signal players_focus_mode_changed(mode: Control.FocusMode)
signal menu_fight_focus_mode_changed(mode: Control.FocusMode)
# --- Toggle menus ---
signal toggle_menu_bottom_emited(on: bool)
signal toggle_menu_items_emited(on: bool)
signal toggle_menu_skills_emited(on: bool)
signal toggle_menu_fight_emited(on: bool)
signal toggle_menu_selection_emited(on: bool)
signal toggle_messager_emited(on: bool)
# --- Buttons ---
signal fight_button_up
signal attack_button_up
signal fight_button_entered
signal run_button_entered
# --- Handle cancel ---
