## Generic class for the battle actions (attack, defend, items, skills).
class_name BattleAction extends Resource

## The action's actor.
var actor: Battler
## The targets of the action.
var targets: Array[Battler] = []
## Data used to identify items and skills.
var data: BattleActionData

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: BattleActionData = null):
	actor = _actor
	targets = _targets
	data = _data
	for target in targets:
		print("[BattleAction%s]. Created action for Actor: " % resource_name, actor.name, " | Target: ", target.name, " | Object: ", data)

## Resolves the action.
@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine):
	for target in targets:
		print("[BattleAction%s]. Resolving action for Actor: " % resource_name, actor.name, " | Target: ", target.name, " | Object: ", data)
