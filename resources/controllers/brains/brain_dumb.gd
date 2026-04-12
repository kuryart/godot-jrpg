class_name BrainDumb extends Brain

func get_action(context: Dictionary) -> BattleAction:
	var foe_index = randi_range(0,context["foes"].size() - 1)
	var foe = context["foes"][foe_index]
	var targets: Array[Battler] = [foe]
	var action = BattleActionAttack.new(context["current_actor"], targets)
	return action
