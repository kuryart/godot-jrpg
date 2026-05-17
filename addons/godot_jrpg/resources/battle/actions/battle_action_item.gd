class_name BattleActionItem extends BattleAction

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: BattleActionData = null) -> void:
	resource_name = "Item"
	super(_actor, _targets, _data)

func resolve(engine: BattleEngine):
	super(engine)
	var item: Item = data.get_data()
	engine.battle_signals.toggle_messenger_emitted.emit(true)
	var is_aoe: bool = item.targets != null and Target.is_target_scope_all(item.targets.scope)
	if is_aoe:
		engine.battle_signals.message_emitted.emit(
			actor.name + " uses " + item.display_name + " on " + Target.all_label(item.targets.side))
		for target in targets:
			item.apply_effects(target, actor, engine)
			if item.vfx:
				engine.battle_signals.vfx_requested_at_battler.emit(item.vfx, target)
		await engine.get_tree().create_timer(1.5).timeout
	else:
		for target in targets:
			engine.battle_signals.message_emitted.emit(
				actor.name + " uses " + item.display_name + " on " + target.name)
			item.apply_effects(target, actor, engine)
			if item.vfx:
				engine.battle_signals.vfx_requested_at_battler.emit(item.vfx, target)
			await engine.get_tree().create_timer(1.5).timeout
	item.consume()
