class_name EffectStatusCure extends Effect

@export var status: Status

func apply(target: Battler):
	target.remove_status(status)
