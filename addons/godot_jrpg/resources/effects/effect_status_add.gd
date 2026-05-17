class_name EffectStatusAdd extends Effect

@export var status: Status

func apply(target: Battler, _attacker: Battler = null, _engine: BattleEngine = null):
	target.add_status(status)
