class_name EffectStatusCure extends Effect

@export var status: Status

func apply(target: Battler, _attacker: Battler = null, _engine: BattleEngine = null):
	target.remove_status(status)
