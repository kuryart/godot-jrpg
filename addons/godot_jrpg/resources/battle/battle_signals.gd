class_name BattleSignals extends Resource

@warning_ignore_start("unused_signal")
# --- Init ---
## Emitted by the BattleEngine when it finishes its internal setup.
## Used to inject the engine reference into UI components that need to read its state.
signal engine_initialized(engine: BattleEngine)
# --- Background ---
signal set_background_emitted(settings: BattleSettings)
# --- Actors ---
signal battler_damaged(battler: Battler)
signal change_player_face_emitted(action: BattleAction)
signal damage_finished
signal enemy_damaged(enemy: BattleEnemyUI)
signal enemy_selected
signal instantiate_enemies_emitted(enemies_settings: Array[EnemySettings], enemies: Array[Enemy], engine: BattleEngine)
signal instantiate_players_emitted(engine: BattleEngine, players: Array[Player])
signal player_changed(player: Player)
signal player_damaged
signal player_selected(player: Player)
signal player_select_ended
signal select_enemy_emitted
signal battler_died(battler: Battler)
# --- Buttons ---
signal attack_button_up
signal defend_button_up
signal items_button_up
signal skills_button_up
signal fight_button_entered
signal fight_button_up
signal run_button_entered
signal run_button_up
signal enemy_button_up
# --- Focus ---
signal define_focus_neighbors_emitted
signal enemies_focus_mode_changed(mode: Control.FocusMode)
signal menu_fight_focus_mode_changed(mode: Control.FocusMode)
signal players_focus_mode_changed(mode: Control.FocusMode)
signal request_player_focus_emitted(player: Player)
signal select_menu_fight_option_emitted(id: int)
signal select_menu_selection_option_emitted(id: int)
signal update_enemy_focus_neighbor_emitted
# --- Toggle menus ---
signal toggle_menu_bottom_emitted(on: bool)
signal toggle_menu_fight_emitted(on: bool)
signal toggle_menu_items_emitted(on: bool)
signal toggle_menu_selection_emitted(on: bool)
signal toggle_menu_skills_emitted(on: bool)
signal toggle_messenger_emitted(on: bool)
# --- Items menu ---
signal item_clicked(item: Item)
signal item_changed(item: Item)
signal select_item_target_emitted(item: Item)
signal select_item_target_one_ally_emitted(item: Item)
signal select_item_target_all_allies_emitted(item: Item)
signal select_item_target_one_enemy_emitted(item: Item)
signal select_item_target_all_enemies_emitted(item: Item)
signal select_item_target_one_both_emitted(item: Item)
signal select_item_target_all_both_emitted(item: Item)
signal select_item_target_self_emitted(item: Item)
signal select_item_target_everyone_emitted(item: Item)
# --- Skills menu ---
signal skill_clicked(skill: Skill)
signal skill_changed(skill: Skill)
signal select_skill_target_emitted(skill: Skill)
signal select_skill_target_one_ally_emitted(skill: Skill)
signal select_skill_target_all_allies_emitted(skill: Skill)
signal select_skill_target_one_enemy_emitted(skill: Skill)
signal select_skill_target_all_enemies_emitted(skill: Skill)
signal select_skill_target_one_both_emitted(skill: Skill)
signal select_skill_target_all_both_emitted(skill: Skill)
signal select_skill_target_self_emitted(skill: Skill)
signal select_skill_target_everyone_emitted(skill: Skill)
# --- Players menu ---
signal go_to_players_menu_emitted
signal all_allies_confirmed_emitted
signal all_enemies_confirmed_emitted
signal self_target_confirmed_emitted
signal all_skill_allies_confirmed_emitted
signal all_skill_enemies_confirmed_emitted
signal self_skill_target_confirmed_emitted
# --- Handle cancel ---
# --- Messenger ---
signal message_emitted(message: String)
# --- Status refreshed ---
signal status_refreshed(engine: BattleEngine)
# --- Battle ended ---
signal inner_battle_ended
