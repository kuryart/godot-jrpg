class_name BattleInputEnemySelect extends BattleInput

var targets: Array[Battler]

func _init(_targets: Array[Battler]):
	targets = _targets

func resolve(engine: BattleEngine):
	if engine.current_phase is BattlePhaseAttackTarget:
		var action = BattleActionAttack.new(engine.current_battler, targets)
		engine.action_pool.append(action)
	elif engine.current_phase is BattlePhaseItemTarget:
		var item = engine.current_phase.item
		var data = BattleActionDataItem.new(item)
		var action = BattleActionItem.new(engine.current_battler, targets, data)
		engine.action_pool.append(action)
	elif engine.current_phase is BattlePhaseSkillTarget:
		var skill = engine.current_phase.skill
		var data = BattleActionDataSkill.new(skill)
		var action = BattleActionSkill.new(engine.current_battler, targets, data)
		engine.action_pool.append(action)

	engine.battle_signals.enemy_selected.emit()
