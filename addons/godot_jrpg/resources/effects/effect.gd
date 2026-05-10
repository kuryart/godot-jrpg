@abstract class_name Effect extends Resource

## When the effect is resolved.
enum RESOLVE_IN {UPKEEP, CLEANUP, PRE_ACTION, POST_ACTION}
## When the effect is resolved.
@export var resolve_in: RESOLVE_IN

@warning_ignore("unused_parameter")
func apply(target: Battler):
	pass
