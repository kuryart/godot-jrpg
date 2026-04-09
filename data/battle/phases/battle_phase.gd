class_name BattlePhase extends Resource

var is_finished: bool = false

@warning_ignore("unused_signal")
signal finished

@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine):
	pass

func end():
	print("[BattlePhase%s] PHASE ENDED: %s" % [resource_name, resource_name])
	is_finished = true
	finished.emit()

@warning_ignore("unused_parameter")
func handle_cancel(engine: BattleEngine):
	pass
