class_name Status extends Resource

@export var duration: int = 1
@export_enum("upkeep", "cleanup", "pre_action", "post_action") var resolve_in: Array[String]

var tick: int = 0

func apply_effects(actor: Battler):
	resolve(actor)

func process_duration() -> bool:
	tick += 1
	return tick >= duration

@warning_ignore("unused_parameter")
func resolve(actor: Battler):
	pass
