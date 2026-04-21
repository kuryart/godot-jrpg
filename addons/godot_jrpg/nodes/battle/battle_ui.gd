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
## The UI for the character's face. 
@onready var face: BattleFace = %Face

## This resource is shared with engine objects to share common battle signals. Just
## be sure to reference the right .tres.
@export var battle_signals: BattleSignals
## The enemy scene to be instantiated.
@export var enemy_scene: PackedScene
## The player scene to be instantiated.
@export var player_scene: PackedScene

## A dictionary to retain the players' UIs. Each key is a [Player], and each 
## value is a [BattlePlayerUI]
var players: Dictionary[Player, BattlePlayerUI]
## A dictionary to retain the enemies' UIs. Each key is a [Enemy], and each 
## value is a [BattleEnemyUI].
var enemies: Dictionary[Enemy, BattleEnemyUI]

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
	battle_signals.set_background_emited.connect(_on_set_background_emited)
	# --- Actors ---
	battle_signals.instantiate_enemies_emited.connect(_on_instantiate_enemies_emited)
	battle_signals.instantiate_players_emited.connect(_on_instantiate_players_emited)
	battle_signals.select_enemy_emited.connect(_on_select_enemy_emited)
	battle_signals.battler_damaged.connect(_on_battler_damaged)
	battle_signals.player_changed.connect(_on_player_changed)
	battle_signals.change_player_face_emited.connect(_on_change_player_face_emited)
	# --- Focus ---
	battle_signals.request_player_focus_emited.connect(_on_request_player_focus_emited)
	battle_signals.define_focus_neighbors_emited.connect(_on_define_focus_neighbors_emited)
	battle_signals.select_menu_selection_option_emited.connect(_on_select_menu_selection_option_emited)
	battle_signals.enemies_focus_mode_changed.connect(_on_enemies_focus_mode_changed)
	battle_signals.players_focus_mode_changed.connect(_on_players_focus_mode_changed)
	battle_signals.menu_fight_focus_mode_changed.connect(_on_menu_fight_focus_mode_changed)
	battle_signals.select_menu_fight_option_emited.connect(_on_select_menu_fight_option_emited)
	battle_signals.update_enemy_focus_neighbor_emited.connect(_on_update_enemy_focus_neighbor_emited)
	# --- Toggle menu ---
	battle_signals.toggle_menu_bottom_emited.connect(_on_toggle_menu_bottom_emited)
	battle_signals.toggle_menu_items_emited.connect(_on_toggle_menu_items_emited)
	battle_signals.toggle_menu_skills_emited.connect(_on_toggle_menu_skills_emited)
	battle_signals.toggle_messenger_emited.connect(_on_toggle_messenger_emited)
	battle_signals.toggle_menu_fight_emited.connect(_on_toggle_menu_fight_emited)
	battle_signals.toggle_menu_selection_emited.connect(_on_toggle_menu_selection_emited)
	# --- Buttons ---
	battle_signals.fight_button_entered.connect(_on_fight_button_entered)
	battle_signals.run_button_entered.connect(_on_run_button_entered)
	# --- Handle cancel ---

## Helper function to wait for node is ready.  
func wait_ready():
	if not is_node_ready(): await ready

# === CONNECTED METHODS ===
# --- Background ---
## Used to set background.
func _on_set_background_emited(settings: BattleSettings):
	await wait_ready()
	background.texture = settings.background
	background.size = settings.background_size

# --- Actors ---
## Used to instantiate enemies.
func _on_instantiate_enemies_emited(enemies_settings: Array[EnemySettings], _enemies: Array[Enemy], engine: BattleEngine):
	await wait_ready()
	for i in range(_enemies.size()):
		var enemy_ui = enemy_scene.instantiate() as BattleEnemyUI
		var enemy_settings = enemies_settings[i]
		var enemy = _enemies[i]
		enemy_ui.setup(enemy, enemy_settings, engine)
		enemies[enemy] = enemy_ui
		enemies_options.add_child(enemy_ui)

## Used to instantiate players. We insert a [Player] into a [BattlePlayerUI].
func _on_instantiate_players_emited(engine: BattleEngine, _players: Array[Player]):
	await wait_ready()
	for player in _players:
		var player_ui = player_scene.instantiate() as BattlePlayerUI
		player_ui.setup(engine, player)
		players[player] = player_ui
		players_options.add_child(player_ui)

## Used when the game asks for enemy selection.
func _on_select_enemy_emited():
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
		await enemy.get_attacked()
	elif battler is Player:
		await face.get_attacked()

## Used to change the face UI based on player changed.
func _on_player_changed(player: Player):
	face.texture = player.face

## Used to change the face UI based on player being the target or the actor of an action.
func _on_change_player_face_emited(action: BattleAction):
	var first_target = action.targets[0]
	face.texture = first_target.face if action.actor is Enemy else action.actor.face

# --- Focus ---
## Define the focus neighbors for enemies for the first time.
func _on_define_focus_neighbors_emited():
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

## Used when the players focus mode was changed. 
func _on_players_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for player in players_options.get_children():
		player.focus_mode = mode

## Used when the fight menu focus mode was changed. 
func _on_menu_fight_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for option in menu_fight_options.get_children():
		option.focus_mode = mode

## Used when the player focus is requested.
func _on_request_player_focus_emited(player: Player):
	await wait_ready()
	var player_ui = players[player]
	player_ui.grab_focus()

## Used when and option from selection menu is selected (fight or run).
func _on_select_menu_selection_option_emited(id: int):
	await wait_ready()
	menu_selection_options.get_children()[id].grab_focus()

## Used when and option from fight menu is selected (attack, defend, items, skills).
func _on_select_menu_fight_option_emited(id: int):
	await wait_ready()
	menu_fight_options.get_children()[id].grab_focus()

## Used to update the enemy focus when an enemy dies, for example, creating a 
## cyclical enemy selection.
func _on_update_enemy_focus_neighbor_emited():
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
func _on_toggle_menu_skills_emited(on: bool):
	await wait_ready()
	menu_skills.show() if on else menu_skills.hide()

## Used to toggle items menu on or off.
func _on_toggle_menu_items_emited(on: bool):
	await wait_ready()
	menu_items.show() if on else menu_items.hide()

## Used to toggle bottom menu on or off.
func _on_toggle_menu_bottom_emited(on: bool):
	await wait_ready()
	menu_bottom.show() if on else menu_bottom.hide()

## Used to toggle mesenger menu on or off.
func _on_toggle_messenger_emited(on: bool):
	await wait_ready()
	messenger.show() if on else messenger.hide()

## Used to toggle fight menu on or off.
func _on_toggle_menu_fight_emited(on: bool):
	await wait_ready()
	menu_fight.show() if on else menu_fight.hide()

## Used to toggle selection menu on or off.
func _on_toggle_menu_selection_emited(on: bool):
	await wait_ready()
	menu_selection.show() if on else menu_selection.hide()
	
# --- Buttons ---
## Used to change the face panel to the fight icon image.
func _on_fight_button_entered():
	face.texture = face.icon_fight

## Used to change the face panel to the run icon image.
func _on_run_button_entered():
	face.texture = face.icon_run
