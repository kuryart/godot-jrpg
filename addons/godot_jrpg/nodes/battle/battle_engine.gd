## The main class for battle logic.
##
## Here we have all the logic separated from UI elements, which are managed by [BattleUI]. There are
## two reasons for this:
##
## [br][br]1. Decoupling;
## [br]2. Usage in simulation and reinforcement learning (RL) agents.
##
## [br][br] The battle engine uses the State design pattern with the [BattlePhase] class to manage the battle
## phases, like [BattlePhaseAttackTarget], [BattlePhaseCleanUp], [BattlePhaseUpkeep], etc., so the phases
## can carry logic too (again to decoupling and to maintain the Single Responsabillity Principle).
##
## [br][br] The core for the battle system is the [member action_pool]. When any battler chooses an
## action (attack, defend, item or skill), the respective [BattleAction] is created and added to the
## pool. They will be resolved in the [BattlePhaseResolveActions], using the battler's speed.
##
## [br][br] The battle settings are defined by [member battle_settings], and we have a [Resource]
## called [BattleSignals], which manages the battle signals. It must be the same resource used in
## [BattleUI], and in the [BattlePhase]s so they can share the same signals.
##
## [br][br] The [member visuals_enabled] is used to toggle visuals on or off, because we don't need
## visuals and UI in the simulation or RL mode, we just need the logic.
class_name BattleEngine extends Node

## This resource is shared with UI objects to share common battle signals. Just
## be sure to reference the right .tres.
@export var battle_signals: BattleSignals
## These are the [BattleSettings], like background, music. etc.
@export var battle_settings: BattleSettings
## You can disable visuals, so the battle will run only in the console. This is
## intended to use with simulation or RL mode. More info in online documentation.
@export var visuals_enabled: bool = false
## A reference to the battle UI.
@export var battle_ui: BattleUI

@export_group("Formulas and Damage")
## Formula used to calculate hit chance.
@export var hit_chance_formula: FormulaHitChance
## Formula used to calculate critical hit chance.
@export var critical_chance_formula: FormulaCriticalChance
## The damage calculator.
@export var damage_calculator: DamageCalculator

## The battlers (enemies + players) in the battle.
var battlers: Array[Battler] = []
## The players in the battle.
var players: Array[Player] = []
## The enemies in the battle.
var enemies: Array[Enemy] = []
## The player that is the leader, i.e., whom can make decisions.
var leader: Player
## The current player in action.
var current_player: Player
## The current battler (enemy or player) in action.
var current_battler: Battler
## The current phase of the battle.
var current_phase: BattlePhase
## The current turn of the battle.
var current_turn: int = 1
## This is the most important variable in the battle. It consists of an array of
## battle actions, which are resolved in [BattlePhaseResolveActions] in order of
## battler's speed.
var action_pool: Array[BattleAction]
## The battle's complete log.
var battle_log: Array[Dictionary] = []

# --- Initialization methods ---
func _ready() -> void:
	GameManager.change_game_state(GameManager.GameStates.BATTLE)
	change_phase(BattlePhaseInit.new())
	if leader.controller is PlayerNPCController:
		leader.controller.think()
	call_deferred(&"_emit_engine_initialized")

func _emit_engine_initialized() -> void:
	battle_signals.engine_initialized.emit(self)

## Initialize essential objects ([BattleSettings] and [BattleUI]). Called by
## [Battle].
func initialize(settings: BattleSettings, ui: BattleUI):
	battle_settings = settings
	battle_ui = ui

## Starts the battle. First we go to the [BattlePhaseStart], then to
## [BattlePhaseSelection].
func start_battle():
	await change_phase(BattlePhaseStart.new())
	await change_phase(BattlePhaseSelection.new())

# --- General battle methods ---
## This function changes and resolves phases.
func change_phase(phase: BattlePhase):
	current_phase = phase
	print("[BattlePhase%s] CURRENT PHASE: %s" % [phase.resource_name, phase.resource_name])
	await phase.resolve(self)
	if not phase.is_finished: await phase.finished

## This function changes the turn.
func change_turn():
	current_turn += 1
	battle_signals.players_focus_mode_changed.emit(Control.FOCUS_ALL)
	battle_signals.menu_fight_focus_mode_changed.emit(Control.FOCUS_ALL)
	change_to_player(get_first_alive_player())
	action_pool.clear()
	battle_signals.toggle_messenger_emitted.emit(false)

## This function removes focus from all elements (enemies, players and menus).
## It's used when the player can't interact with anything, like when the enemy is
## taking damage.
func clear_focus():
	battle_signals.enemies_focus_mode_changed.emit(Control.FOCUS_NONE)
	battle_signals.players_focus_mode_changed.emit(Control.FOCUS_NONE)
	battle_signals.menu_fight_focus_mode_changed.emit(Control.FOCUS_NONE)

## This function uses the inserting sort algorithm to calculate the action order
## of players and enemies based on speeds.
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

## Verifies if the battle ended (victory or game over)
func check_battle_end() -> bool:
	var alive_players = players.filter(func(p: Player): return p.is_alive())
	var alive_enemies = enemies.filter(func(e: Enemy): return e.is_alive())

	if alive_players.is_empty():
		print("[BattleEngine] Game Over!")
		change_phase(BattlePhaseGameOver.new())
		return true

	if alive_enemies.is_empty():
		print("[BattleEngine] Victory!")
		change_phase(BattlePhaseVictory.new())
		return true

	return false

## Counts how many items of this specific type are already in the action queue.
func get_queued_item_count(target_item: Item) -> int:
	var count: int = 0
	for action in action_pool:
		if action is BattleActionItem and action.data.get_data() == target_item:
			count += 1
	return count

## Removes all actions from the pool that belong to the given player.
func remove_player_action(player: Player) -> void:
	for i in range(action_pool.size() - 1, -1, -1):
		if action_pool[i].actor == player:
			print("[BattleEngine] Removed action ", action_pool[i].resource_name, " for ", player.name)
			action_pool.remove_at(i)

# --- Battlers methods ---
## Adds a batller to the arena.
func add_battle_battler(actor: Battler):
	battlers.append(actor)

	if actor is Player:
		players.append(actor)
	elif actor is Enemy:
		enemies.append(actor)

## Change the current player to a target player.
func change_to_player(player: Player):
	current_player = player
	battle_signals.request_player_focus_emitted.emit(player)

## Change the current batller to a target battler.
func change_to_battler(battler: Battler):
	current_battler = battler

## Change to the next player. If there's no player to change to, it ends the
## [BattlePhasePlayers] and starts the BattlePhaseResolveActions].
func change_to_next_player():
	var next_player = get_next_player()

	if players.find(next_player) <= players.find(current_player):
		current_phase.end()
		await change_phase(BattlePhaseResolveActions.new())
		return

	change_to_player(next_player)

## Used to cycle players forward or backward. Direction is: 1 for next player,
## -1 for previous player. Used by [method get_next_player] and
## [method get_previous_player].
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

## It gets next player using [method cycle_player] forwards.
func get_next_player() -> Player:
	return cycle_player(1)

## It gets previous player using [method cycle_player] backwards.
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

## It emits two signals to warns an enemy needs to be selected.
func select_enemy():
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	battle_signals.select_enemy_emitted.emit()

## Manages the enemies decisions that will be added to [member action_pool]
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

## Gets a list of dead battlers and checks if it's empty. If the list is empty,
## return. Else, it [method process_battler_death] and [method refresh_battle_state].
func validate_deaths():
	var dead_list = get_dead_battlers()

	if dead_list.is_empty():
		return

	await process_battler_death(dead_list)
	refresh_enemy_state()

## Returns all the dead battlers.
func get_dead_battlers() -> Array[Battler]:
	return battlers.filter(func(b): return b.current_hp <= 0 and b.is_alive())

## Executes the battler's death.
func process_battler_death(targets: Array[Battler]):
	for battler in targets:
		clear_focus()
		battle_signals.toggle_messenger_emitted.emit(true)

		var death_text = "%s defeated!" % battler.name
		battle_signals.message_emitted.emit(death_text)
		await battler.die()
		battle_signals.battler_died.emit(battler)
		await get_tree().create_timer(2.0).timeout

		battle_signals.toggle_messenger_emitted.emit(false)

## Refresh enemy state, i.e., update enemy focus neighbors and move focus to next
## enemy.
func refresh_enemy_state() -> void:
	battle_signals.update_enemy_focus_neighbor_emitted.emit()
	move_focus_to_next_enemy()

## Move the focus to the next alive enemy.
func move_focus_to_next_enemy() -> void:
	var current_focus = get_viewport().gui_get_focus_owner()
	if current_focus  is Enemy and not current_focus.is_alive():
		var next_enemy = enemies.find_custom(func(enemy: Enemy): return enemy.is_alive())
		if next_enemy != -1:
			enemies[next_enemy].grab_focus()

## Process status duration, i.e., adds a tick.
func process_status_duration():
	for player in players:
		player.update_status()

	for enemy in enemies:
		enemy.update_status()

# --- Menus methods ---
## It shall go to the selection menu.
func go_to_selection_menu():
	battle_signals.toggle_menu_fight_emitted.emit(false)
	battle_signals.toggle_menu_selection_emitted.emit(true)
	battle_signals.select_menu_selection_option_emitted.emit(0)

## It shall go to the players menu.
func go_to_players_menu():
	battle_signals.toggle_menu_selection_emitted.emit(false)
	battle_signals.toggle_menu_fight_emitted.emit(true)
	battle_signals.menu_fight_focus_mode_changed.emit(Control.FOCUS_NONE)
	battle_signals.players_focus_mode_changed.emit(Control.FOCUS_ALL)
	change_to_player(current_player)

## It shall go to the fight menu.
func go_to_fight_menu():
	battle_signals.toggle_menu_items_emitted.emit(false)
	battle_signals.toggle_menu_skills_emitted.emit(false)
	battle_signals.enemies_focus_mode_changed.emit(Control.FOCUS_NONE)
	battle_signals.menu_fight_focus_mode_changed.emit(Control.FOCUS_ALL)
	battle_signals.select_menu_fight_option_emitted.emit(0)

# --- Attack methods ---
## Calculate the physical damage.
func calculate_physical_damage(attacker: Battler, defender: Battler) -> int:
	var damage = damage_calculator.calculate_physical_damage(attacker, defender, self)
	return int(max(damage, 0))

## Checks if the attack is critical.
func is_attack_critical(attacker: Battler, defender: Battler) -> bool:
	var param = FormulaCriticalChanceParameter.new()
	param.attacker = attacker
	param.defender = defender

	var chance = critical_chance_formula.calculate(param)
	return randf() <= chance

## Checks if the attack missed.
func is_attack_missed(attacker: Battler, defender: Battler) -> bool:
	var param = FormulaHitChanceParameter.new()
	param.attacker = attacker
	param.defender = defender

	var chance = hit_chance_formula.calculate(param)
	return not randf() <= chance

## Checks if the effect missed.
func is_effect_missed(effect: Effect, attacker: Battler, defender: Battler) -> bool:
	var param = FormulaEffectChanceParameter.new()
	param.attacker = attacker
	param.defender = defender

	var chance = effect.chance_formula.calculate(param)
	return not randf() <= chance

## Checks if the effect dealt critical damage.
func is_effect_critical(effect: Effect, attacker: Battler, defender: Battler) -> bool:
	var param = FormulaEffectCriticalChanceParameter.new()
	param.attacker = attacker
	param.defender = defender

	var chance = effect.critical_chance_formula.calculate(param)
	return randf() <= chance

# --- Signals methods ---
## Connected to `enemy_selected` signal. It changes to next player, ends target
## selection phases, which are attack, items and skills phases. If any target is ended, 
## it change phase to [BattlePhasePlayers].
func _on_enemy_selected():
	change_to_next_player()
	if current_phase is BattlePhaseAttackTarget or \
	current_phase is BattlePhaseItemTarget or \
	current_phase is BattlePhaseSkillTarget:
		current_phase.end()
	else:
		return
	await change_phase(BattlePhasePlayers.new())

func _on_player_select_ended():
	current_phase.end()
	change_to_next_player()
	await change_phase(BattlePhasePlayers.new())

## Connected to item_clicked signal. It starts the [BattlePhaseItemPlayerSelect].
func _on_item_clicked(item: Item):
	await change_phase(BattlePhaseItemTarget.new(item))

## Connected to skill_clicked signal. It starts the [BattlePhaseSkillTarget].
func _on_skill_clicked(skill: Skill):
	await change_phase(BattlePhaseSkillTarget.new(skill))

## Connected to self_target_confirmed_emitted. Creates item action targeting the current battler.
func _on_self_target_confirmed():
	var phase := current_phase as BattlePhaseItemTarget
	var targets: Array[Battler] = [current_battler]
	var data = BattleActionDataItem.new(phase.item)
	action_pool.append(BattleActionItem.new(current_battler, targets, data))
	battle_signals.enemy_selected.emit()

## Connected to all_enemies_confirmed_emitted. Creates item action for all alive enemies.
func _on_all_enemies_confirmed():
	var phase := current_phase as BattlePhaseItemTarget
	var alive_enemies: Array[Battler] = []
	for e in enemies:
		if e.is_alive():
			alive_enemies.append(e)
	var data = BattleActionDataItem.new(phase.item)
	action_pool.append(BattleActionItem.new(current_battler, alive_enemies, data))
	battle_signals.enemy_selected.emit()

## Connected to all_skill_allies_confirmed_emitted. Creates skill action for all alive allies.
func _on_all_skill_allies_confirmed():
	var phase := current_phase as BattlePhaseSkillTarget
	var alive_allies: Array[Battler] = []
	for p in players:
		if p.is_alive():
			alive_allies.append(p)
	var data = BattleActionDataSkill.new(phase.skill)
	action_pool.append(BattleActionSkill.new(current_battler, alive_allies, data))
	battle_signals.enemy_selected.emit()

## Connected to all_skill_enemies_confirmed_emitted. Creates skill action for all alive enemies.
func _on_all_skill_enemies_confirmed():
	var phase := current_phase as BattlePhaseSkillTarget
	var alive_enemies: Array[Battler] = []
	for e in enemies:
		if e.is_alive():
			alive_enemies.append(e)
	var data = BattleActionDataSkill.new(phase.skill)
	action_pool.append(BattleActionSkill.new(current_battler, alive_enemies, data))
	battle_signals.enemy_selected.emit()

## Connected to self_skill_target_confirmed_emitted. Creates skill action targeting the current battler.
func _on_self_skill_target_confirmed():
	var phase := current_phase as BattlePhaseSkillTarget
	var targets: Array[Battler] = [current_battler]
	var data = BattleActionDataSkill.new(phase.skill)
	action_pool.append(BattleActionSkill.new(current_battler, targets, data))
	battle_signals.enemy_selected.emit()

## Connected to all_everyone_confirmed_emitted. Creates item action for all alive battlers.
func _on_all_item_everyone_confirmed():
	var phase := current_phase as BattlePhaseItemTarget
	var alive_battlers: Array[Battler] = battlers.filter(func(b: Battler): return b.is_alive())
	var data = BattleActionDataItem.new(phase.item)
	action_pool.append(BattleActionItem.new(current_battler, alive_battlers, data))
	battle_signals.enemy_selected.emit()

## Connected to all_skill_everyone_confirmed_emitted. Creates skill action for all alive battlers.
func _on_all_skill_everyone_confirmed():
	var phase := current_phase as BattlePhaseSkillTarget
	var alive_battlers: Array[Battler] = battlers.filter(func(b: Battler): return b.is_alive())
	var data = BattleActionDataSkill.new(phase.skill)
	action_pool.append(BattleActionSkill.new(current_battler, alive_battlers, data))
	battle_signals.enemy_selected.emit()

## Connected to all_allies_confirmed_emitted. Creates item action for all alive allies.
func _on_all_allies_confirmed():
	var phase := current_phase as BattlePhaseItemTarget
	var alive_allies: Array[Battler] = []
	for p in players:
		if p.is_alive():
			alive_allies.append(p)
	var data = BattleActionDataItem.new(phase.item)
	action_pool.append(BattleActionItem.new(current_battler, alive_allies, data))
	battle_signals.enemy_selected.emit()
