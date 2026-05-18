## The UI for the battle.
## 
## The UI is separated from [BattleEngine]. There are two reasons for this:
##
## [br][br]1. Decoupling; 
## [br]2. Usage in simulation and reinforcement learning (RL) agents.
##
## [br][br] @onready variables get the UI nodes that will be used by the class.
##
## [br][br] We have several connections to signals. The connected methods are 
## divided in Background signals, Actors signals, Focus signals,
## Toggle menu signals, Buttons Signals, Handle cancel signals.
class_name BattleUI extends Control

@warning_ignore_start("standalone_ternary")

## The UI node for background.
@onready var background: TextureRect = %Background
## The UI node for enemies options (the parent node for enemies nodes).
@onready var enemies_options: Control = %Enemies
## The UI node for players options (the parent node for players nodes).
@onready var players_options: VBoxContainer = %Players
## The UI node for items menu.
@onready var menu_items: BattleMenuItems = %MenuItems
## The UI node for skills menu.
@onready var menu_skills: BattleMenuSkills = %MenuSkills
## The UI node for bottom menu.
@onready var menu_bottom: PanelContainer = %MenuBottom
## The UI node for fight menu (when whe select between attack, defend, item or skill).
@onready var menu_fight: PanelContainer = %MenuFight
## The UI node for selection menu (when whe select between fight or run).
@onready var menu_selection: PanelContainer = %MenuSelection
## The UI node for fight menu options (attack, defend, item, skill).
@onready var menu_fight_options: VBoxContainer = %MenuFightOptions
## The UI node for selection menu options (fight or run).
@onready var menu_selection_options: VBoxContainer = %MenuSelectionOptions
## The UI for the panel which shows battle messages.
@onready var messenger: PanelContainer = %Messenger
## The UI for the label which shows battle messages.
@onready var messenger_label: RichTextLabel = %MessengerLabel
## The UI for the character's face. 
@onready var face: BattleFace = %Face
## The grid for the items menu.
@onready var items_grid: GridContainer = %ItemsGrid

## This resource is shared with engine objects to share common battle signals. Just
## be sure to reference the right .tres.
@export var battle_signals: BattleSignals
## The enemy scene to be instantiated.
@export var enemy_scene: PackedScene
## The player scene to be instantiated.
@export var player_scene: PackedScene
## The status icon used to inform the players status
@export var status_icon: PackedScene

## A dictionary to retain the players' UIs. Each key is a [Player], and each
## value is a [BattlePlayerUI]
var players: Dictionary[Player, BattlePlayerUI]
## A dictionary to retain the enemies' UIs. Each key is a [Enemy], and each
## value is a [BattleEnemyUI].
var enemies: Dictionary[Enemy, BattleEnemyUI]
## Tracks the current active player, updated via player_changed signal.
var current_player: Player
## True while both+all target mode is active; drives group-flash on focus change.
var _both_all_flash_active: bool = false

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		set_process(false)
		set_physics_process(false)
		process_mode = PROCESS_MODE_DISABLED
		hide()

## Connects signals, divided by Background signals, Actors signals, Focus signals,
## Toggle menu signals, Buttons Signals, Handle cancel signals.
func setup_ui():
	# === CONNECTIONS ===
	# --- Background ---
	battle_signals.set_background_emitted.connect(_on_set_background_emitted)
	# --- Actors ---
	battle_signals.instantiate_enemies_emitted.connect(_on_instantiate_enemies_emitted)
	battle_signals.instantiate_players_emitted.connect(_on_instantiate_players_emitted)
	battle_signals.select_enemy_emitted.connect(_on_select_enemy_emitted)
	battle_signals.battler_damaged.connect(_on_battler_damaged)
	battle_signals.vfx_requested_at_battler.connect(_on_vfx_requested_at_battler)
	battle_signals.player_changed.connect(_on_player_changed)
	battle_signals.change_player_face_emitted.connect(_on_change_player_face_emitted)
	battle_signals.battler_died.connect(_on_battler_died)
	battle_signals.player_select_ended.connect(_on_player_select_ended)
	# --- Focus ---
	battle_signals.request_player_focus_emitted.connect(_on_request_player_focus_emitted)
	battle_signals.define_focus_neighbors_emitted.connect(_on_define_focus_neighbors_emitted)
	battle_signals.select_menu_selection_option_emitted.connect(_on_select_menu_selection_option_emitted)
	battle_signals.enemies_focus_mode_changed.connect(_on_enemies_focus_mode_changed)
	battle_signals.players_focus_mode_changed.connect(_on_players_focus_mode_changed)
	battle_signals.menu_fight_focus_mode_changed.connect(_on_menu_fight_focus_mode_changed)
	battle_signals.select_menu_fight_option_emitted.connect(_on_select_menu_fight_option_emitted)
	battle_signals.update_enemy_focus_neighbor_emitted.connect(_on_update_enemy_focus_neighbor_emitted)
	# --- Toggle menu ---
	battle_signals.toggle_menu_bottom_emitted.connect(_on_toggle_menu_bottom_emitted)
	battle_signals.toggle_menu_items_emitted.connect(_on_toggle_menu_items_emitted)
	battle_signals.toggle_menu_skills_emitted.connect(_on_toggle_menu_skills_emitted)
	battle_signals.toggle_messenger_emitted.connect(_on_toggle_messenger_emitted)
	battle_signals.toggle_menu_fight_emitted.connect(_on_toggle_menu_fight_emitted)
	battle_signals.toggle_menu_selection_emitted.connect(_on_toggle_menu_selection_emitted)
	# --- Buttons ---
	battle_signals.fight_button_entered.connect(_on_fight_button_entered)
	battle_signals.run_button_entered.connect(_on_run_button_entered)
	# --- Item target selection ---
	battle_signals.go_to_players_menu_emitted.connect(_on_go_to_players_menu_emitted)
	battle_signals.select_item_target_all_allies_emitted.connect(_on_select_item_target_all_allies_emitted)
	battle_signals.select_item_target_one_enemy_emitted.connect(_on_select_item_target_one_enemy_emitted)
	battle_signals.select_item_target_all_enemies_emitted.connect(_on_select_item_target_all_enemies_emitted)
	battle_signals.all_allies_confirmed_emitted.connect(_on_all_allies_confirmed_emitted)
	battle_signals.all_enemies_confirmed_emitted.connect(_on_all_enemies_confirmed_emitted)
	battle_signals.select_item_target_one_both_emitted.connect(_on_select_item_target_one_both_emitted)
	battle_signals.select_item_target_all_both_emitted.connect(_on_select_item_target_all_both_emitted)
	battle_signals.select_item_target_everyone_emitted.connect(_on_select_item_target_everyone_emitted)
	battle_signals.all_everyone_confirmed_emitted.connect(_on_all_everyone_confirmed_emitted)
	battle_signals.select_item_target_self_emitted.connect(_on_select_item_target_self_emitted)
	battle_signals.self_target_confirmed_emitted.connect(_on_self_target_confirmed_emitted)
	# --- Skill target selection ---
	battle_signals.select_skill_target_all_allies_emitted.connect(_on_select_skill_target_all_allies_emitted)
	battle_signals.select_skill_target_one_enemy_emitted.connect(_on_select_skill_target_one_enemy_emitted)
	battle_signals.select_skill_target_all_enemies_emitted.connect(_on_select_skill_target_all_enemies_emitted)
	battle_signals.all_skill_allies_confirmed_emitted.connect(_on_all_skill_allies_confirmed_emitted)
	battle_signals.all_skill_enemies_confirmed_emitted.connect(_on_all_skill_enemies_confirmed_emitted)
	battle_signals.select_skill_target_one_both_emitted.connect(_on_select_skill_target_one_both_emitted)
	battle_signals.select_skill_target_all_both_emitted.connect(_on_select_skill_target_all_both_emitted)
	battle_signals.select_skill_target_everyone_emitted.connect(_on_select_skill_target_everyone_emitted)
	battle_signals.all_skill_everyone_confirmed_emitted.connect(_on_all_skill_everyone_confirmed_emitted)
	battle_signals.select_skill_target_self_emitted.connect(_on_select_skill_target_self_emitted)
	battle_signals.self_skill_target_confirmed_emitted.connect(_on_self_skill_target_confirmed_emitted)
	# --- Handle cancel ---
	# --- Messenger ---
	battle_signals.message_emitted.connect(_on_message_emitted)
	# --- Status refreshed
	battle_signals.status_refreshed.connect(_on_status_refreshed)

## Helper function to wait for node is ready.  
func wait_ready():
	if not is_node_ready(): await ready

## Used to refresh the status icons.
func refresh_status():
	for player_ui: BattlePlayerUI in players_options.get_children():
		var status_container = player_ui.get_node("%StatusContainer")
		for status_ui: TextureRect in status_container.get_children():
			status_ui.queue_free()
	
	for player_ui: BattlePlayerUI in players_options.get_children():
		var status_container = player_ui.get_node("%StatusContainer")
		for s in player_ui.player.status:
			var status_icon_ui = status_icon.instantiate() as TextureRect
			status_icon_ui.texture = s.icon
			status_container.add_child(status_icon_ui)

# === CONNECTED METHODS ===
# --- Background ---
## Used to set background.
func _on_set_background_emitted(settings: BattleSettings):
	await wait_ready()
	background.texture = settings.background
	background.size = settings.background_size

# --- Actors ---
## Used to instantiate enemies.
func _on_instantiate_enemies_emitted(enemies_settings: Array[EnemySettings], _enemies: Array[Enemy], engine: BattleEngine):
	await wait_ready()
	for i in range(_enemies.size()):
		var enemy_ui = enemy_scene.instantiate() as BattleEnemyUI
		var enemy_settings = enemies_settings[i]
		var enemy = _enemies[i]
		enemy_ui.setup(enemy, enemy_settings, engine)
		enemies[enemy] = enemy_ui
		enemies_options.add_child(enemy_ui)

## Used to instantiate players. We insert a [Player] into a [BattlePlayerUI].
func _on_instantiate_players_emitted(engine: BattleEngine, _players: Array[Player]):
	await wait_ready()
	for player in _players:
		var player_ui = player_scene.instantiate() as BattlePlayerUI
		player_ui.setup(engine, player)
		players[player] = player_ui
		players_options.add_child(player_ui)
		for s in player.status:
			var status_icon_ui = status_icon.instantiate() as TextureRect
			var status_container = player_ui.get_node("%StatusContainer")
			status_icon_ui.texture = s.icon
			status_container.add_child(status_icon_ui)

## Used when the game asks for enemy selection.
func _on_select_enemy_emitted():
	await wait_ready()
	var enemies_array: Array[Enemy] = enemies.keys()
	var enemies_alive: Array[Enemy] = enemies_array.filter(func(enemy: Enemy): return enemy.is_alive())
	enemies[enemies_alive[0]].grab_focus()

## Used when the battler's damaged. It can call [codeblock]get_attacked()[/codeblock] in both Enemy and
## Player.
func _on_battler_damaged(battler: Battler):
	await wait_ready()
	if battler is Enemy:
		var enemy = enemies[battler as Enemy]
		battle_signals.battler_value_displayed.emit(
			enemy.get_global_rect().get_center(), battler.last_damage_taken, false)
		await enemy.get_attacked()
	elif battler is Player:
		face.player = battler as Player
		battle_signals.battler_value_displayed.emit(
			face.get_global_rect().get_center(), battler.last_damage_taken, false)
		battle_signals.player_damaged.emit(face)
		await face.get_attacked()

## Used to change the face UI based on player changed.
func _on_player_changed(player: Player):
	current_player = player
	face.texture = player.face

## Used to change the face UI based on player being the target or the actor of an action.
func _on_change_player_face_emitted(action: BattleAction):
	var first_target = action.targets[0]
	face.texture = first_target.face if action.actor is Enemy else action.actor.face

## Used when a battler is defeated.
func _on_battler_died(battler: Battler):
	await wait_ready()
	if battler is Enemy:
		var enemy_ui = enemies[battler as Enemy]
		enemy_ui.die()
	elif battler is Player:
		var player_ui = players[battler as Player]
		refresh_status()
		player_ui.die()

## Used to refresh the status icons.
func _on_status_refreshed(engine: BattleEngine):
	refresh_status()

func _on_player_select_ended() -> void:
	var children = players_options.get_children()
	var count = children.size()
	
	for i in range(count):
		var player_ui = children[i] as BattlePlayerUI
		var path = player_ui.get_path()
		player_ui.focus_neighbor_left = path
		player_ui.focus_neighbor_right = path
		player_ui.focus_neighbor_top = path
		player_ui.focus_neighbor_bottom = path

# --- Focus ---
## Define the focus neighbors for enemies for the first time.
func _on_define_focus_neighbors_emitted():
	await wait_ready()
	var enemies_array_children = enemies_options.get_children()
	var enemies_array_size: int = enemies_array_children.size()
	for i in range(enemies_array_size):
		var enemy: BattleEnemyUI = enemies_options.get_child(i) as BattleEnemyUI
		enemy.focus_neighbor_bottom = enemy.get_path()
		enemy.focus_neighbor_top = enemy.get_path()
		var j = i - 1
		if j < 0: j = enemies_array_size - 1
		enemy.focus_neighbor_left = enemies_array_children[j].get_path()
		j = i + 1
		if j > enemies_array_size - 1: j = 0
		enemy.focus_neighbor_right = enemies_array_children[j].get_path()

## Used when the enemies focus mode was changed.
func _on_enemies_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for enemy in enemies_options.get_children():
		enemy.focus_mode = mode
		if mode == Control.FOCUS_NONE:
			(enemy as BattleEnemyUI).stop_flash()
	if mode == Control.FOCUS_NONE:
		_cleanup_both_all_flash()

## Used when the players focus mode was changed.
func _on_players_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for player in players_options.get_children():
		player.focus_mode = mode
		if mode == Control.FOCUS_NONE:
			(player as BattlePlayerUI).stop_flash()

## Used when the fight menu focus mode was changed. 
func _on_menu_fight_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for option in menu_fight_options.get_children():
		option.focus_mode = mode

## Used when the player focus is requested.
func _on_request_player_focus_emitted(player: Player):
	await wait_ready()
	var player_ui = players[player]
	player_ui.grab_focus()

## Used when and option from selection menu is selected (fight or run).
func _on_select_menu_selection_option_emitted(id: int):
	await wait_ready()
	menu_selection_options.get_children()[id].grab_focus()

## Used when and option from fight menu is selected (attack, defend, items, skills).
func _on_select_menu_fight_option_emitted(id: int):
	await wait_ready()
	menu_fight_options.get_children()[id].grab_focus()

## Used to update the enemy focus when an enemy dies, for example, creating a 
## cyclical enemy selection.
func _on_update_enemy_focus_neighbor_emitted():
	await wait_ready()
	var enemies_array: Array[BattleEnemyUI] = enemies.values()
	var active_enemies: Array[BattleEnemyUI] = enemies_array.filter(func(enemy: BattleEnemyUI): return enemy.enemy.is_alive())
	var count = active_enemies.size()
	
	for i in range(count):
		var enemy: BattleEnemyUI = active_enemies[i]
		enemy.focus_mode = Control.FOCUS_ALL
		
		var left = active_enemies[(i - 1 + count) % count]
		var right = active_enemies[(i + 1) % count]
		
		enemy.focus_neighbor_left = left.get_path()
		enemy.focus_neighbor_right = right.get_path()
		enemy.focus_neighbor_top = enemy.get_path()
		enemy.focus_neighbor_bottom = enemy.get_path()

# --- Toggle menus ---
## Used to toggle skills menu on or off.
func _on_toggle_menu_skills_emitted(on: bool):
	await wait_ready()
	if on:
		menu_skills.show()
		await menu_skills.rebuild_menu()
		menu_skills.focus_first()
	else:
		menu_skills.hide()

## Used to toggle items menu on or off.
func _on_toggle_menu_items_emitted(on: bool):
	await wait_ready()
	if on:
		menu_items.show()
		menu_items.refresh_item_list()
	else:
		menu_items.hide()
		var first_button: Button = menu_fight_options.get_child(0)
		first_button.grab_focus()

## Used to toggle bottom menu on or off.
func _on_toggle_menu_bottom_emitted(on: bool):
	await wait_ready()
	menu_bottom.show() if on else menu_bottom.hide()

## Used to toggle mesenger menu on or off.
func _on_toggle_messenger_emitted(on: bool):
	await wait_ready()
	messenger.show() if on else messenger.hide()

## Used to toggle fight menu on or off.
func _on_toggle_menu_fight_emitted(on: bool):
	await wait_ready()
	menu_fight.show() if on else menu_fight.hide()

## Used to toggle selection menu on or off.
func _on_toggle_menu_selection_emitted(on: bool):
	await wait_ready()
	menu_selection.show() if on else menu_selection.hide()
	
# --- Buttons ---
## Used to change the face panel to the fight icon image.
func _on_fight_button_entered():
	face.texture = face.icon_fight

## Used to change the face panel to the run icon image.
func _on_run_button_entered():
	face.texture = face.icon_run

# --- Item target player selection ---
## Flashes all alive enemies in loop. Waits for action button to confirm.
func _on_select_item_target_all_enemies_emitted(_item: Item):
	await wait_ready()
	menu_items.hide()
	for enemy_ui in enemies.values():
		if (enemy_ui as BattleEnemyUI).enemy.is_alive():
			(enemy_ui as BattleEnemyUI).flash()

## Flashes current player UI in loop. Waits for action button to confirm.
func _on_select_item_target_self_emitted(_item: Item):
	await wait_ready()
	menu_items.hide()
	var player_ui = players.get(current_player)
	if player_ui:
		player_ui.flash()

## Stops current player flash when self target is confirmed.
func _on_self_target_confirmed_emitted():
	await wait_ready()
	var player_ui = players.get(current_player)
	if player_ui:
		player_ui.stop_flash()

## Stops all enemy flash animations when all-enemies action is confirmed.
func _on_all_enemies_confirmed_emitted():
	await wait_ready()
	for enemy_ui in enemies.values():
		(enemy_ui as BattleEnemyUI).stop_flash()
	_cleanup_both_all_flash()

## Hides items menu and enables enemy selection with existing flash animation.
func _on_select_item_target_one_enemy_emitted(_item: Item):
	await wait_ready()
	menu_items.hide()
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	battle_signals.select_enemy_emitted.emit()

## Starts looping flash on all alive player name labels. Waits for action button.
func _on_select_item_target_all_allies_emitted(_item: Item):
	await wait_ready()
	menu_items.hide()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.flash()

## Stops all flash animations when all-allies action is confirmed.
func _on_all_allies_confirmed_emitted():
	await wait_ready()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui:
			bpui.stop_flash()
	_cleanup_both_all_flash()

## Hides items/skills menu and enables player buttons as selectable targets.
func _on_go_to_players_menu_emitted():
	await wait_ready()
	menu_items.hide()
	menu_skills.hide()
	for player_ui in players_options.get_children():
		var bpui := player_ui as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.focus_mode = Control.FOCUS_ALL
	var alive: Array = players_options.get_children().filter(
		func(p): return p is BattlePlayerUI and (p as BattlePlayerUI).player.is_alive())
	if not alive.is_empty():
		(alive[0] as BattlePlayerUI).grab_focus()

# --- Skill target player selection ---
## Flashes all alive enemies in loop. Waits for action button to confirm.
func _on_select_skill_target_all_enemies_emitted(_skill: Skill):
	await wait_ready()
	menu_skills.hide()
	for enemy_ui in enemies.values():
		if (enemy_ui as BattleEnemyUI).enemy.is_alive():
			(enemy_ui as BattleEnemyUI).flash()

## Flashes current player UI in loop. Waits for action button to confirm.
func _on_select_skill_target_self_emitted(_skill: Skill):
	await wait_ready()
	menu_skills.hide()
	var player_ui = players.get(current_player)
	if player_ui:
		player_ui.flash()

## Stops current player flash when self skill target is confirmed.
func _on_self_skill_target_confirmed_emitted():
	await wait_ready()
	var player_ui = players.get(current_player)
	if player_ui:
		player_ui.stop_flash()

## Stops all enemy flash animations when all-enemies skill action is confirmed.
func _on_all_skill_enemies_confirmed_emitted():
	await wait_ready()
	for enemy_ui in enemies.values():
		(enemy_ui as BattleEnemyUI).stop_flash()
	_cleanup_both_all_flash()

## Hides skills menu and enables enemy selection with existing flash animation.
func _on_select_skill_target_one_enemy_emitted(_skill: Skill):
	await wait_ready()
	menu_skills.hide()
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	battle_signals.select_enemy_emitted.emit()

## Starts looping flash on all alive player name labels. Waits for action button.
func _on_select_skill_target_all_allies_emitted(_skill: Skill):
	await wait_ready()
	menu_skills.hide()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.flash()

## Stops all player flash animations when all-allies skill action is confirmed.
func _on_all_skill_allies_confirmed_emitted():
	await wait_ready()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui:
			bpui.stop_flash()
	_cleanup_both_all_flash()

## Sets up focus neighbors so enemies navigate down to players and the top player
## navigates up to the first enemy. Used for both+one and both+all target modes.
func _setup_both_focus_neighbors() -> void:
	var alive_enemy_uis: Array = enemies.values().filter(
		func(e): return (e as BattleEnemyUI).enemy.is_alive())
	var alive_player_uis: Array = players_options.get_children().filter(
		func(p): return p is BattlePlayerUI and (p as BattlePlayerUI).player.is_alive())

	if alive_enemy_uis.is_empty() or alive_player_uis.is_empty():
		return

	var first_enemy := alive_enemy_uis[0] as BattleEnemyUI
	var first_player := alive_player_uis[0] as BattlePlayerUI

	for eu in alive_enemy_uis:
		var enemy_ui := eu as BattleEnemyUI
		enemy_ui.focus_neighbor_bottom = first_player.get_path()
		enemy_ui.focus_neighbor_top = enemy_ui.get_path()

	for i in range(alive_player_uis.size()):
		var bpui := alive_player_uis[i] as BattlePlayerUI
		bpui.focus_neighbor_left = bpui.get_path()
		bpui.focus_neighbor_right = bpui.get_path()
		bpui.focus_neighbor_top = first_enemy.get_path() if i == 0 \
			else (alive_player_uis[i - 1] as BattlePlayerUI).get_path()
		bpui.focus_neighbor_bottom = bpui.get_path() if i == alive_player_uis.size() - 1 \
			else (alive_player_uis[i + 1] as BattlePlayerUI).get_path()

## Deactivates both+all group-flash mode and disconnects the viewport focus listener.
func _cleanup_both_all_flash() -> void:
	_both_all_flash_active = false
	var vp := get_viewport()
	if vp and vp.gui_focus_changed.is_connected(_on_both_all_focus_changed):
		vp.gui_focus_changed.disconnect(_on_both_all_focus_changed)
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui:
			bpui.remove_theme_stylebox_override("focus")
			var path = bpui.get_path()
			bpui.focus_neighbor_left = path
			bpui.focus_neighbor_right = path
			bpui.focus_neighbor_top = path
			bpui.focus_neighbor_bottom = path

## Switches group-level flash based on which UI group receives focus.
func _on_both_all_focus_changed(focused_node: Control) -> void:
	if not _both_all_flash_active:
		return
	if focused_node is BattleEnemyUI:
		for enemy_ui in enemies.values():
			if (enemy_ui as BattleEnemyUI).enemy.is_alive():
				(enemy_ui as BattleEnemyUI).flash()
		for child in players_options.get_children():
			var bpui := child as BattlePlayerUI
			if bpui:
				bpui.stop_flash()
	elif focused_node is BattlePlayerUI:
		for enemy_ui in enemies.values():
			(enemy_ui as BattleEnemyUI).stop_flash()
		for child in players_options.get_children():
			var bpui := child as BattlePlayerUI
			if bpui and bpui.player.is_alive():
				bpui.flash()

## Enables individual enemy+player focus navigation for item targeting one of both sides.
func _on_select_item_target_one_both_emitted(_item: Item):
	await wait_ready()
	menu_items.hide()
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.focus_mode = Control.FOCUS_ALL
	_setup_both_focus_neighbors()
	var alive_enemies := enemies.values().filter(func(e): return (e as BattleEnemyUI).enemy.is_alive())
	if not alive_enemies.is_empty():
		(alive_enemies[0] as BattleEnemyUI).grab_focus()

## Flashes all enemies by default; up/down focus navigation switches which group flashes.
func _on_select_item_target_all_both_emitted(_item: Item):
	await wait_ready()
	menu_items.hide()
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.focus_mode = Control.FOCUS_ALL
			bpui.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for enemy_ui in enemies.values():
		if (enemy_ui as BattleEnemyUI).enemy.is_alive():
			(enemy_ui as BattleEnemyUI).flash()
	_setup_both_focus_neighbors()
	_both_all_flash_active = true
	get_viewport().gui_focus_changed.connect(_on_both_all_focus_changed)
	var alive_enemies := enemies.values().filter(func(e): return (e as BattleEnemyUI).enemy.is_alive())
	if not alive_enemies.is_empty():
		(alive_enemies[0] as BattleEnemyUI).grab_focus()

## Enables individual enemy+player focus navigation for skill targeting one of both sides.
func _on_select_skill_target_one_both_emitted(_skill: Skill):
	await wait_ready()
	menu_skills.hide()
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.focus_mode = Control.FOCUS_ALL
	_setup_both_focus_neighbors()
	var alive_enemies := enemies.values().filter(func(e): return (e as BattleEnemyUI).enemy.is_alive())
	if not alive_enemies.is_empty():
		(alive_enemies[0] as BattleEnemyUI).grab_focus()

## Flashes all enemies by default; up/down focus navigation switches which group flashes.
func _on_select_skill_target_all_both_emitted(_skill: Skill):
	await wait_ready()
	menu_skills.hide()
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.focus_mode = Control.FOCUS_ALL
			bpui.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for enemy_ui in enemies.values():
		if (enemy_ui as BattleEnemyUI).enemy.is_alive():
			(enemy_ui as BattleEnemyUI).flash()
	_setup_both_focus_neighbors()
	_both_all_flash_active = true
	get_viewport().gui_focus_changed.connect(_on_both_all_focus_changed)
	var alive_enemies := enemies.values().filter(func(e): return (e as BattleEnemyUI).enemy.is_alive())
	if not alive_enemies.is_empty():
		(alive_enemies[0] as BattleEnemyUI).grab_focus()

## Flashes all alive enemies and players simultaneously for item targeting everyone.
func _on_select_item_target_everyone_emitted(_item: Item):
	await wait_ready()
	menu_items.hide()
	for enemy_ui in enemies.values():
		if (enemy_ui as BattleEnemyUI).enemy.is_alive():
			(enemy_ui as BattleEnemyUI).flash()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.flash()

## Stops all flash animations when everyone item action is confirmed.
func _on_all_everyone_confirmed_emitted():
	await wait_ready()
	for enemy_ui in enemies.values():
		(enemy_ui as BattleEnemyUI).stop_flash()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui:
			bpui.stop_flash()

## Flashes all alive enemies and players simultaneously for skill targeting everyone.
func _on_select_skill_target_everyone_emitted(_skill: Skill):
	await wait_ready()
	menu_skills.hide()
	for enemy_ui in enemies.values():
		if (enemy_ui as BattleEnemyUI).enemy.is_alive():
			(enemy_ui as BattleEnemyUI).flash()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui and bpui.player.is_alive():
			bpui.flash()

## Stops all flash animations when everyone skill action is confirmed.
func _on_all_skill_everyone_confirmed_emitted():
	await wait_ready()
	for enemy_ui in enemies.values():
		(enemy_ui as BattleEnemyUI).stop_flash()
	for child in players_options.get_children():
		var bpui := child as BattlePlayerUI
		if bpui:
			bpui.stop_flash()

# --- VFX ---
## Resolves the screen position of a battler's UI node and forwards the VFX request.
func _on_vfx_requested_at_battler(vfx: VFX, battler: Battler) -> void:
	await wait_ready()
	var position := Vector2.ZERO
	if battler is Enemy:
		var enemy_ui := enemies.get(battler as Enemy) as BattleEnemyUI
		if enemy_ui:
			position = enemy_ui.get_global_rect().get_center()
			if vfx.target_flash:
				enemy_ui.play_target_flash(vfx.target_flash as BattlerFlash)
	elif battler is Player:
		position = face.get_global_rect().get_center()
		if vfx.target_flash:
			face.play_target_flash(vfx.target_flash as BattlerFlash)
	if position != Vector2.ZERO:
		battle_signals.vfx_play_at_position.emit(vfx, position)

# --- Messenger ---
## Used to pass messages to messenger.
func _on_message_emitted(message: String):
	await wait_ready()
	messenger_label.text = message
