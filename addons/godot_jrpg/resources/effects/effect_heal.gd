class_name EffectHeal extends Effect

@export var amount: int = 20

func apply(target: Battler):
	var max_hp = target.stats.hp.get_value()
	target.current_hp = int(min(max_hp, target.current_hp + amount))
	print("Healed %d HP. Current HP: %d" % [amount, target.current_hp])
