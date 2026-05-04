class_name EffectStatusAdd extends Effect

@export var status: Status

func apply(target: Battler):
	target.add_status(status)
