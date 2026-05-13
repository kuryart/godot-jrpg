class_name BattlePhaseItemTarget extends BattlePhase

var targets: Target
var effects: EffectList

func _init(item: Item) -> void:
	resource_name = "TargetSelection"
	targets = item.targets
	effects = item.effects

func resolve(engine: BattleEngine):
	if Target.is_target_side_enemies(targets.side):
		if Target.is_target_scope_one(targets.scope):
			pass
		elif Target.is_target_scope_all(targets.scope):
			pass

	elif Target.is_target_side_allies(targets.side):
		if Target.is_target_scope_one(targets.scope):
			pass
		elif Target.is_target_scope_all(targets.scope):
			pass

	elif Target.is_target_side_both(targets.side):
		if Target.is_target_scope_one(targets.scope):
			pass
		elif Target.is_target_scope_all(targets.scope):
			pass

	elif Target.is_target_side_self(targets.side):
		pass

	elif Target.is_target_side_everyone(targets.side):
		pass
