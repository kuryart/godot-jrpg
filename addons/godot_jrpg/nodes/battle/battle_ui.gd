class_name BattleUI extends Control

@warning_ignore_start("standalone_ternary")

@onready var background: TextureRect = get_node("%Background")
@onready var enemies_options: Control = get_node("%Enemies")
@onready var players_options: VBoxContainer = get_node("%Players")
@onready var menu_items: BattleMenuItems = get_node("%MenuItems")
@onready var menu_skills: BattleMenuSkills = get_node("%MenuSkills")
@onready var menu_bottom: PanelContainer = get_node("%MenuBottom")
@onready var menu_fight: PanelContainer = get_node("%MenuFight")
@onready var menu_selection: PanelContainer = get_node("%MenuSelection")
@onready var menu_fight_options: VBoxContainer = get_node("%MenuFightOptions")
@onready var menu_selection_options: VBoxContainer = get_node("%MenuSelectionOptions")
@onready var messager: PanelContainer = get_node("%Messager")
@onready var face: BattleFace = get_node("%Face")

@export var battle_signals: BattleSignals
@export var enemy_scene: PackedScene
@export var player_scene: PackedScene

var players: Dictionary[Player, BattlePlayerUI]
var enemies: Dictionary[Enemy, BattleEnemyUI]

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		set_process(false)
		set_physics_process(false)
		process_mode = PROCESS_MODE_DISABLED
		hide()

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
	# --- Toggle manu ---
	battle_signals.toggle_menu_bottom_emited.connect(_on_toggle_menu_bottom_emited)
	battle_signals.toggle_menu_items_emited.connect(_on_toggle_menu_items_emited)
	battle_signals.toggle_menu_skills_emited.connect(_on_toggle_menu_skills_emited)
	battle_signals.toggle_messager_emited.connect(_on_toggle_messager_emited)
	battle_signals.toggle_menu_fight_emited.connect(_on_toggle_menu_fight_emited)
	battle_signals.toggle_menu_selection_emited.connect(_on_toggle_menu_selection_emited)
	# --- Buttons ---
	battle_signals.fight_button_entered.connect(_on_fight_button_entered)
	battle_signals.run_button_entered.connect(_on_run_button_entered)
	# --- Handle cancel ---

func wait_ready():
	if not is_node_ready(): await ready

# === CONNECTED METHODS ===
# --- Background ---
func _on_set_background_emited(settings: BattleSettings):
	await wait_ready()
	background.texture = settings.background
	background.size = settings.background_size

# --- Actors ---
func _on_instantiate_enemies_emited(enemies_settings: Array[EnemySettings], _enemies: Array[Enemy], engine: BattleEngine):
	await wait_ready()
	for i in range(_enemies.size()):
		var enemy_ui = enemy_scene.instantiate() as BattleEnemyUI
		var enemy_settings = enemies_settings[i]
		var enemy = _enemies[i]
		enemy_ui.setup(enemy, enemy_settings, engine)
		enemies[enemy] = enemy_ui
		enemies_options.add_child(enemy_ui)

func _on_instantiate_players_emited(engine: BattleEngine, _players: Array[Player]):
	await wait_ready()
	for player in _players:
		var player_ui = player_scene.instantiate() as BattlePlayerUI
		player_ui.setup(engine, player)
		players[player] = player_ui
		players_options.add_child(player_ui)

func _on_select_enemy_emited():
	await wait_ready()
	var enemies_array: Array[Enemy] = enemies.keys()
	var enemies_alive: Array[Enemy] = enemies_array.filter(func(enemy: Enemy): return enemy.is_alive())
	enemies[enemies_alive[0]].grab_focus()
	
func _on_battler_damaged(battler: Battler):
	await wait_ready()
	if battler is Enemy:
		var enemy = enemies[battler as Enemy]
		await enemy.get_attacked()
	elif battler is Player:
		await face.get_attacked()

func _on_player_changed(player: Player):
	face.texture = player.face
	
func _on_change_player_face_emited(action: BattleAction):
	var first_target = action.targets[0]
	face.texture = first_target.face if action.actor is Enemy else action.actor.face

# --- Focus ---
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

func _on_enemies_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for enemy in enemies_options.get_children():
		enemy.focus_mode = mode

func _on_players_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for player in players_options.get_children():
		player.focus_mode = mode

func _on_menu_fight_focus_mode_changed(mode: Control.FocusMode):
	await wait_ready()
	for option in menu_fight_options.get_children():
		option.focus_mode = mode

func _on_request_player_focus_emited(player: Player):
	await wait_ready()
	var player_ui = players[player]
	player_ui.grab_focus()

func _on_select_menu_selection_option_emited(id: int):
	await wait_ready()
	menu_selection_options.get_children()[id].grab_focus()
	
func _on_select_menu_fight_option_emited(id: int):
	await wait_ready()
	menu_fight_options.get_children()[id].grab_focus()
	
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
func _on_toggle_menu_skills_emited(on: bool):
	await wait_ready()
	menu_skills.show() if on else menu_skills.hide()
	
func _on_toggle_menu_items_emited(on: bool):
	await wait_ready()
	menu_items.show() if on else menu_items.hide()

func _on_toggle_menu_bottom_emited(on: bool):
	await wait_ready()
	menu_bottom.show() if on else menu_bottom.hide()

func _on_toggle_messager_emited(on: bool):
	await wait_ready()
	messager.show() if on else messager.hide()

func _on_toggle_menu_fight_emited(on: bool):
	await wait_ready()
	menu_fight.show() if on else menu_fight.hide()
	
func _on_toggle_menu_selection_emited(on: bool):
	await wait_ready()
	menu_selection.show() if on else menu_selection.hide()
	
# --- Buttons ---
func _on_fight_button_entered():
	face.texture = face.icon_fight

func _on_run_button_entered():
	face.texture = face.icon_run
