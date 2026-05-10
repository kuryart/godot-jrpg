class_name BattleActionDefend extends BattleAction

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: Resource = null) -> void:
	resource_name = "Defend"
	super(_actor, _targets, _data)

func resolve(engine: BattleEngine):
	pass
