class_name BattleActionItem extends BattleAction

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: BattleActionData = null) -> void:
	resource_name = "Item"
	super(_actor, _targets, _data)

@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine):
	super(engine)
	var item: Item = data.get_data()

	for target in targets:
		item.apply_effects(target, actor, engine)
	item.consume()
