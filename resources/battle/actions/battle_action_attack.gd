class_name BattleActionAttack extends BattleAction

func _init(_actor: Battler = null, _targets: Array[Battler] = [], _data: Resource = null) -> void:
	resource_name = "Attack"
	super(_actor, _targets, _data)

func resolve(engine: BattleEngine):
	super(engine)
	for target in targets:
		if target.is_alive():
			if not engine.is_attack_missed(actor, target):
				take_damage(engine, target)
				engine.battle_signals.battler_damaged.emit(target)

func take_damage(engine: BattleEngine, target: Battler):
	var damage = engine.calculate_physical_damage(actor, target)
	target.take_damage(damage)
