## Generic class used by [BattleEngine] to calculate battle logic for any battler, 
## which can be a [BattlePlayer] or a [BattleEnemy].
class_name BattleBattler extends RefCounted

## A reference to the battler data.
var data: Battler
## The battler's stats.
var stats: Stats
## The battler current HP.
var current_hp: int
## The battler current MP.
var current_mp: int
## The controller used by battler. It can be Manual, NPC, Simulation, or RL (Reinforcement Learning). Learn more in [BattlerController].
var controller: BattlerController
## The battler current status.
var status: Array[Status] = []

func _init(battler: Battler, ctrl: BattlerController):
	data = battler
	controller = ctrl
	stats = battler.stats.duplicate(true)
	current_hp = stats.hp.get_value()
	current_mp = stats.mp.get_value()

## Adds a status to battler.
func add_status(_status: Status) -> void:
	var new_status = _status.duplicate()
	status.append(new_status)

## Updates the status for battler.
func update_status() -> void:
	var expired = []
	for s in status:
		s.apply_effects(self)
		if s.process_duration():
			expired.append(s)
	
	for s in expired:
		status.erase(s)

## Checks if battler is alive.
func is_alive() -> bool:
	if not is_instance_valid(self) or is_queued_for_deletion(): return false
	return not status.any(func(s): return s is StatusDead)

## Checks if battler is stunned.
func is_stunned() -> bool:
	return status.any(func(s): return s is StatusFrozen or s is StatusParalyzed)

## Makes the battler take damage
func take_damage(damage: int) -> void:
	current_hp -= damage

## Kills the battler
func die() -> void:
	pass
