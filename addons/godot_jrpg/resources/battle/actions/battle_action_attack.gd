class_name BattleActionAttack extends BattleAction

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: Resource = null) -> void:
	resource_name = "Attack"
	super(_actor, _targets, _data)

func resolve(engine: BattleEngine):
	super(engine)
	engine.battle_signals.toggle_messenger_emited.emit(true)
	for target in targets:
		if target.is_alive():
			if not engine.is_attack_missed(actor, target):
				engine.battle_signals.message_emited.emit(actor.name + " attacks " + target.name)
				take_damage(engine, target)
				engine.battle_signals.battler_damaged.emit(target)
				await engine.battle_signals.damage_finished
			else:
				engine.battle_signals.message_emited.emit(actor.name + " missed the attack")
				print("[BattleActionAttack] ", actor.name, " missed the attack to ", target.name)

func take_damage(engine: BattleEngine, target: Battler):
	var damage = engine.calculate_physical_damage(actor, target)
	target.take_damage(damage)
