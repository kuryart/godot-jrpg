class_name BattleActionSkill extends BattleAction

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: BattleActionData = null) -> void:
	resource_name = "Skill"
	super(_actor, _targets, _data)

func resolve(engine: BattleEngine):
	super(engine)
	var skill = data.get_data()
	engine.battle_signals.toggle_messenger_emitted.emit(true)
	skill.pay_cost(actor)
	var is_aoe: bool = skill.targets != null and Target.is_target_scope_all(skill.targets.scope)
	var verb: String = skill.message if not skill.message.is_empty() else "uses"
	if is_aoe:
		engine.battle_signals.message_emitted.emit(
			actor.name + " " + verb + " " + skill.display_name + " on " + Target.all_label(skill.targets.side))
		for target in targets:
			skill.apply_effects(target, actor, engine)
			if skill.vfx:
				engine.battle_signals.vfx_requested_at_battler.emit(skill.vfx, target)
		await engine.get_tree().create_timer(1.5).timeout
	else:
		for target in targets:
			engine.battle_signals.message_emitted.emit(
				actor.name + " " + verb + " " + skill.display_name + " on " + target.name)
			skill.apply_effects(target, actor, engine)
			if skill.vfx:
				engine.battle_signals.vfx_requested_at_battler.emit(skill.vfx, target)
			await engine.get_tree().create_timer(1.5).timeout
