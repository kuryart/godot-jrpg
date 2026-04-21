## This is a superclass for battle phases, like [BattlePhaseInit] or 
## [BattlePhaseUpkeep].
class_name BattlePhase extends Resource

## Flag to know if the phase is finished.
var is_finished: bool = false

## Signal emited when the phase is finished.
@warning_ignore("unused_signal")
signal finished

## The main function for the phase, where everything inside the phase is resolved.
## E.g.: [BattlePhaseInit] initialize things, [BattlePhaseUpkeep] keeps the upkeeps,
## and so on.
@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine):
	pass

## This function ends the phase.
func end():
	print("[BattlePhase%s] PHASE ENDED: %s" % [resource_name, resource_name])
	is_finished = true
	finished.emit()

## The cancel button is handled by the [BattlePhase] because is more practical.
@warning_ignore("unused_parameter")
func handle_cancel(engine: BattleEngine):
	pass
