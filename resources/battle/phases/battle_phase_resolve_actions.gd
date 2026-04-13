## The [BattlePhase] that resolves the [BattleAction]s.
##
## This is the core for the whole battle system, because here we resolve the actions choosen by players 
## and enemies.
class_name BattlePhaseResolveActions extends BattlePhase

func _init() -> void:
	resource_name = "ResolveActions"

## This function is separated in three sections: pre-action, action and post-action. It is the core
## of the entire battle system, because it resolves the actions choosen by players and enemies. It
## iterates by the actions in the action pool and resolve one by one.
func resolve(engine: BattleEngine):
	engine.clear_focus()
	engine.manage_enemies_decisions()
	engine.calc_action_order()	
	
	for action in engine.action_pool:
		# --- Pre-action ---
		if not can_actor_act(action): continue
		if not validate_targets(action, engine): continue
		resolve_pre_action_effects()
		engine.check_for_death()
		
		# --- Action ---
		engine.battle_signals.change_player_face_emited.emit(action)
		await action.resolve(engine)
		
		# --- Post-action ---
	
	end()

## Checks if player can act, id est, if player is dead or stunned.
func can_actor_act(action: BattleAction) -> bool:
	if not action.actor.is_alive(): return false
	if action.actor.is_stunned(): return false
	
	return true

## First we check if target is alive. If it is dead, we try to find an alternative target. Then we set
## this alternative target in place of the old target if we found it, or removes the old target from 
## the list if we don't find it. Finally, we return if the targets list is empty or not.
func validate_targets(action: BattleAction, engine: BattleEngine):
	for i in range(action.targets.size() - 1, -1, -1):
		var target = action.targets[i]
		
		if not target.is_alive():
			var new_target = get_alternative_target(target, engine)
			if new_target:
				action.targets[i] = new_target
				print("[BattlePhaseResolveActions] Target ", target.data.name, " is dead. Redirecting to ", new_target.data.name)
			else:
				action.targets.remove_at(i)
	
	return not action.targets.is_empty()

## Tries to find an alternative target, id est, returns the first alive enemy or the first alive player.
## Returns null if no one was found.
func get_alternative_target(target: Battler, engine: BattleEngine) -> Battler:
	if target is Enemy:
		return engine.get_first_alive_enemy()
	
	if target is Player:
		return engine.get_first_alive_player()
		
	return null

## Resolves the effects that happens before an action is resolved.
func resolve_pre_action_effects():
	pass
