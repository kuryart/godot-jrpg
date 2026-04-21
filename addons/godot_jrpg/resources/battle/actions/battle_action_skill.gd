class_name BattleActionSkill extends BattleAction

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: BattleActionData = null) -> void:
	resource_name = "Skill"
	super(_actor, _targets, _data)

@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine):
	super(engine)
	var skill = data.get_data()
	
	for target in targets:
		skill.use(target)
