class_name BattleAction extends Resource

var actor: BattleBattler
var targets: Array[BattleBattler] = []
var data: BattleActionData

func _init(_actor: BattleBattler = null, _targets: Array[BattleBattler] = [], _data: Resource = null):
	actor = _actor
	targets = _targets
	data = _data
	print("[BattleAction%s]. Actor: " % resource_name, actor, " | Target: ", targets, " | Object: ", data)

@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine):
	pass
