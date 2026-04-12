class_name BattleAction extends Resource

var actor: Battler
var targets: Array[Battler] = []
var data: BattleActionData

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: Resource = null):
	actor = _actor
	targets = _targets
	data = _data
	for target in targets:
		print("[BattleAction%s]. Created action for Actor: " % resource_name, actor.name, " | Target: ", target.name, " | Object: ", data)

@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine):
	for target in targets:
		print("[BattleAction%s]. Resolving action for Actor: " % resource_name, actor.name, " | Target: ", target.name, " | Object: ", data)
