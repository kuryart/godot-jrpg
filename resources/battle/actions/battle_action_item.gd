class_name BattleActionItem extends BattleAction

@warning_ignore("unused_parameter")
func resolve(engine: BattleEngine): 
	var item = data
	if not item: return
	
	for target in targets:
		item.use(target)
