## Generic class that describes data, like stats and controller, for a battler. 
## It's like a battler character sheet with logic.
class_name Battler extends Actor

## The battler stats.
@export var stats: Stats
## The battler current status.
@export var status: Array[Status]
## The controller used by battler. It can be Manual, NPC, Simulation, or RL (Reinforcement Learning). Learn more in [BattlerController].
@export var controller: BattlerController
## The battler current HP. It emits a signal on changing.
@export var current_hp: int:
	set(val):
		current_hp = clamp(val, 0, stats.hp.get_value())
		if hp_changed.get_connections().size() > 0:
			hp_changed.emit(current_hp)
## The battler current MP. It emits a signal on changing.
@export var current_mp: int:
	set(val):
		current_mp = clamp(val, 0, stats.mp.get_value())
		if mp_changed.get_connections().size() > 0:
			mp_changed.emit(current_mp)

@warning_ignore_start("unused_signal")
## Used to change values in [Bar] and [BarLabel].
signal hp_changed
signal mp_changed

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
	print("[Battler] ", name, " took ", damage, " damage.")

## Kills the battler
func die() -> void:
	pass
