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
## The [TraitList] for the battler.
@export var traits: TraitList
## The battler elements. This can alter damage when used with traits. 
@export var elements: Array[Element]
## The list of skill of the player
@export var skills: Array[Skill]

## The class used to collect all traits in player, class, status, equip, etc.
var trait_aggregator: TraitAggregator

@warning_ignore_start("unused_signal")
## Used to change values in [Bar] and [BarLabel].
signal hp_changed
signal mp_changed

func _init() -> void:
	trait_aggregator = TraitAggregator.new(self)

## Adds a status to battler.
func add_status(_status: Status) -> void:
	var new_status = _status.duplicate()
	status.append(new_status)
	trait_aggregator.refresh()

## Removes a status safely by checking its name.
func remove_status(status_to_remove: Status) -> bool:
	var removed = false
	for i in range(status.size() - 1, -1, -1):
		if status[i].name == status_to_remove.name:
			status.remove_at(i)
			removed = true
	
	if removed:
		trait_aggregator.refresh()
		
	return removed

## Updates the status for battler.
func update_status() -> void:
	var expired: Array[Status] = []
	for s in status:
		s.apply_effects(self)
		if s.process_duration():
			expired.append(s)
	for s in expired:
		remove_status(s)

## Checks if battler is alive.
func is_alive() -> bool:
	if not is_instance_valid(self) or is_queued_for_deletion(): return false
	return not status.any(func(s: Status): return s.is_dead_state)

## Checks if battler is stunned.
func is_stunned() -> bool:
	#return status.any(func(s): return s is StatusFrozen or s is StatusParalyzed)
	return false

## Makes the battler take damage
func take_damage(damage: int) -> void:
	current_hp -= damage
	print("[Battler] ", name, " took ", damage, " damage.")

## Kills the battler
func die() -> void:
	pass

# --- Get stats methods ---
# -- Main stats --
## Get max hp from the battler
func get_max_hp() -> int:
	var base_val = float(stats.hp.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.HP, base_val)
	return int(final_val)

## Get max mp from the battler
func get_max_mp() -> int:
	var base_val = float(stats.mp.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.MP, base_val)
	return int(final_val)

## Get attack from the battler
func get_attack() -> int:
	var base_val = float(stats.attack.get_value()) 
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.ATTACK, base_val)
	return int(final_val)

## Get defense from the battler
func get_defense() -> int:
	var base_val = float(stats.defense.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.DEFENSE, base_val)
	return int(final_val)

## Get intelligence from the battler
func get_intelligence() -> int:
	var base_val = float(stats.intelligence.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.INTELLIGENCE, base_val)
	return int(final_val)

## Get speed from the battler
func get_speed() -> int:
	var base_val = float(stats.speed.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.SPEED, base_val)
	return int(final_val)

## Get accuracy from the battler
func get_accuracy() -> int:
	var base_val = float(stats.accuracy.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.ACCURACY, base_val)
	return int(final_val)

## Get evasion from the battler
func get_evasion() -> int:
	var base_val = float(stats.evasion.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.EVASION, base_val)
	return int(final_val)

## Get luck from the battler
func get_luck() -> int:
	var base_val = float(stats.luck.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.LUCK, base_val)
	return int(final_val)

# -- Other stats
## Get the hp regeneration rate from the battler
func get_hp_regen() -> int:
	var base_val = float(stats.hp_regen.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.HP_REGEN, base_val)
	return int(final_val)

## Get the mp regeneration rate from the battler
func get_mp_regen() -> int:
	var base_val = float(stats.mp_regen.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.MP_REGEN, base_val)
	return int(final_val)

## Get the critical chance rate from the battler
func get_critical() -> int:
	var base_val = float(stats.critical.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.CRITICAL, base_val)
	return int(final_val)

## Get the critical dodge chance rate from the battler
func get_critical_dodge() -> int:
	var base_val = float(stats.critical_dodge.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.CRITICAL_DODGE, base_val)
	return int(final_val)

## Get the magical dodge chance rate from the battler
func get_magical_dodge() -> int:
	var base_val = float(stats.magical_dodge.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.MAGICAL_DODGE, base_val)
	return int(final_val)

## Get the reflection (skill) chance rate from the battler
func get_reflection() -> int:
	var base_val = float(stats.reflection.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.REFLECTION, base_val)
	return int(final_val)

## Get the counter-attack (attack) chance rate from the battler
func get_counter_attack() -> int:
	var base_val = float(stats.counter_attack.get_value())
	var final_val = trait_aggregator.get_stat_modified(Stat.ID.COUNTER_ATTACK, base_val)
	return int(final_val)
