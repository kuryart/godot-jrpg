class_name BattleInputPlayerSelect extends BattleInput

var targets: Array[Battler]

func _init(_targets: Array[Battler]):
	targets = _targets

func resolve(engine: BattleEngine):
	if engine.current_phase is BattlePhaseItemTarget:
		var item = engine.current_phase.item
		var data = BattleActionDataItem.new(item)
		engine.action_pool.append(BattleActionItem.new(engine.current_battler, targets, data))
	elif engine.current_phase is BattlePhaseSkillTarget:
		var skill = engine.current_phase.skill
		var data = BattleActionDataSkill.new(skill)
		engine.action_pool.append(BattleActionSkill.new(engine.current_battler, targets, data))

	engine.battle_signals.player_select_ended.emit()
