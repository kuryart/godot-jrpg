## The main class for battle logic.
##
## Here we have all the logic separated from UI elements, which are managed by [BattleUI]. There are 
## two reasons for this:
##
## [br][br]1. Decoupling; 
## [br]2. Usage in simulation and reinforcement learning (RL) agents.
##
## [br][br] The battle engine uses the State design pattern with the [BattlePhase] class to manage the battle 
## phases, like [BattlePhaseAttack], [BattlePhaseItemTarget], [BattlePhaseUpkeep], etc., so the phases 
## can carry logic too (again to decoupling and to maintain the Single Responsabillity Principle).
##
## [br][br] The core for the battle system is the [member action_pool]. When any battler chooses an
## action (attack, defend, item or skill), the respective [BattleAction] is created and added to the
## pool. They will be resolved in the [BattlePhaseResolveActions], using the battler's speed.
##
## [br][br] The battle settings are defined by [member battle_settings], and we have a [Resource]
## called [BattleSignals], which manages the battle signals. It must be the same resource used in 
## [BattleUI], so they can share the same signals.
##
## [br][br] The [member visuals_enabled] is used to toggle visuals on or off, because we don't need
## visuals and UI in the simulation or RL mode, we just need the logic.
class_name BattleEngine extends Node

@export var battle_signals: BattleSignals
@export var battle_settings: BattleSettings
@export var visuals_enabled: bool = false
@export var battle_ui: BattleUI

@export_group("Formulas")
@export var hit_chance_formula: FormulaHitChance
@export var physical_formula: FormulaDamage
@export var critical_chance_formula: FormulaCriticalChance
@export var critical_damage_formula: FormulaCriticalDamage

var battlers: Array[Battler] = []
var players: Array[Player] = []
var enemies: Array[Enemy] = []
var leader: Player
var current_player: Player
var current_battler: Battler
var current_phase: BattlePhase
var current_turn: int = 1
var action_pool: Array[BattleAction]
var is_busy: bool = false
var battle_log: Array[Dictionary] = []

# --- Initialization methods ---
func _ready() -> void:
	change_phase(BattlePhaseInit.new())
	if leader.controller is PlayerNPCController:
		leader.controller.think()

func initialize(settings: BattleSettings, ui: BattleUI):
	battle_settings = settings
	battle_ui = ui

func start_battle():
	await change_phase(BattlePhaseStart.new())
	await change_phase(BattlePhaseSelection.new())

# --- General battle methods ---
func change_phase(phase: BattlePhase):
	is_busy = true
	current_phase = phase
	print("[BattlePhase%s] CURRENT PHASE: %s" % [phase.resource_name, phase.resource_name])
	phase.resolve(self)
	if not phase.is_finished: await phase.finished
	is_busy = false

func change_turn():
	current_turn = 1
	battle_signals.players_focus_mode_changed.emit(Control.FOCUS_ALL)
	battle_signals.menu_fight_focus_mode_changed.emit(Control.FOCUS_ALL)
	change_to_player(get_first_alive_player())
	action_pool.clear()
	battle_signals.toggle_messager_emited.emit(false)

func resolve_battle():
	clear_focus()
	manage_enemies_decisions()
	calc_action_order()
	current_phase.end()
	change_phase(BattlePhaseResolveActions.new())

func clear_focus():
	battle_signals.enemies_focus_mode_changed.emit(Control.FOCUS_NONE)
	battle_signals.players_focus_mode_changed.emit(Control.FOCUS_NONE)
	battle_signals.menu_fight_focus_mode_changed.emit(Control.FOCUS_NONE)

func calc_action_order():
	# Inserting Sort algorithm
	var pool = action_pool
	var n = pool.size()
	
	for i in range(1, n):
		var current_action = pool[i]
		var key_speed = current_action.actor.stats.speed.get_value()
		var j = i - 1

		while j >= 0 and pool[j].actor.stats.speed.get_value() < key_speed:
			pool[j + 1] = pool[j]
			j = j - 1
			
		pool[j + 1] = current_action 

	for action in action_pool:
		print("[BattleActionOrder] Actor: ", action.actor.name, " | Speed: ", action.actor.stats.speed.get_value(), " | Action: ", action.resource_name)

# --- Battlers methods ---
func add_battle_battler(actor: Battler):
	battlers.append(actor)
	
	if actor is Player:
		players.append(actor)
	elif actor is Enemy:
		enemies.append(actor)

func change_to_player(player: Player):
	current_player = player
	battle_signals.request_player_focus_emited.emit(player)
	
func change_to_battler(battler: Battler):
	current_battler = battler

## Change to the next player. If there's no player to change to, it starts the [BattlePhaseUpkeep].
func change_to_next_player():
	var next_player = get_next_player()
	
	if players.find(next_player) <= players.find(current_player):
		current_phase.end()
		await change_phase(BattlePhaseUpkeep.new())
		return
	
	change_to_player(next_player)

## Used to cycle players forward or backward. Direction is: 1 for next player, -1 for previous player. Used by [method get_next_player] and [method get_previous_player].
func cycle_player(direction: int = 1) -> Player:
	# Circular calculus algorithm to avoid Index Out of Bounds problems
	var start_index = players.find(current_player)
	var count = players.size()
	
	for i in range(1, count + 1):
		var next_index = (start_index + (i * direction) + count) % count
		var player = players[next_index]
		if player.is_alive():
			return player
	return null

## It gets next player using [method cycle_player].
func get_next_player() -> Player:
	return cycle_player(1)

## It gets previous player using [method cycle_player].
func get_previous_player() -> Player:
	return cycle_player(-1)

## Returns first alive [Player]. If there's no alive player, returns null.
func get_first_alive_player() -> Player:
	var alive_players = players.filter(func(player): return player.is_alive())
	return alive_players[0] if alive_players.size() > 0 else null

## Returns first alive [Enemy]. If there's no alive enemy, returns null.
func get_first_alive_enemy() -> Enemy:
	var alive_enemies = enemies.filter(func(e): return e.is_alive())
	return alive_enemies[0] if alive_enemies.size() > 0 else null

func select_enemy():
	battle_signals.update_enemy_focus_neighbor_emited.emit()
	battle_signals.select_enemy_emited.emit()
	
func manage_enemies_decisions():
	for enemy in enemies:
		var context = {
			"foes": players,
			"allies": enemies,
			"current_actor": enemy,
			"turn_number": current_turn
		}
		var action = enemy.controller.brain.get_action(context)
		action_pool.append(action)
		
func check_for_death() -> void:
	var death_occurred = false
		
	for battler in battlers:
		if battler.current_hp <= 0 and battler.is_alive():
			await battler.die()
			death_occurred = true
	
	if death_occurred:
		battle_signals.update_enemy_focus_neighbor_emited.emit()
		move_focus_to_next_enemy()

func move_focus_to_next_enemy() -> void:
	var current_focus = get_viewport().gui_get_focus_owner()
	if current_focus is Enemy and not current_focus.is_active():
		var next_enemy = enemies.find_custom(func(enemy: Enemy): return enemy.is_alive())
		if next_enemy != -1:
			enemies[next_enemy].grab_focus()

# --- Menus methods ---
func go_to_selection_menu():
	battle_signals.toggle_menu_fight_emited.emit(false)
	battle_signals.toggle_menu_selection_emited.emit(true)
	battle_signals.select_menu_selection_option_emited.emit(0)
	
func go_to_players_menu():
	battle_signals.toggle_menu_selection_emited.emit(false)
	battle_signals.toggle_menu_fight_emited.emit(true)
	change_to_player(current_player)
	
func go_to_fight_menu():
	battle_signals.select_menu_fight_option_emited.emit(0)

# --- Attack methods ---
func calculate_physical_damage(attacker: Battler, defender: Battler) -> int:
	var param = FormulaDamageParameter.new()
	param.attacker = attacker
	param.defender = defender
	var damage = physical_formula.calculate(param)
	if is_attack_critical(attacker, defender):
		damage = calculate_critical_damage(damage)
	
	return damage
	
func calculate_critical_damage(damage: int) -> int:
	var param = FormulaCriticalDamageParameter.new()
	
	var critical_multiplier = critical_damage_formula.calculate(param)
	return int(critical_multiplier * damage)

func is_attack_critical(attacker: Battler, defender: Battler) -> bool:
	var param = FormulaCriticalChanceParameter.new()
	param.attacker = attacker
	param.defender = defender
	
	var chance = critical_chance_formula.calculate(param)
	return randf() <= chance

func is_attack_missed(attacker: Battler, defender: Battler) -> bool:
	var param = FormulaHitChanceParameter.new()
	param.attacker = attacker
	param.defender = defender

	var chance = hit_chance_formula.calculate(param)
	return randf() <= chance

# --- Signals methods ---
func _on_enemy_selected():
	change_to_next_player()
	current_phase.end()
	await change_phase(BattlePhasePlayers.new())
