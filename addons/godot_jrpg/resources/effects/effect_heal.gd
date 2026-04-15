class_name EffectHeal extends Effect

@export var amount: int = 20

func apply(target: Battler):
	# Cura o ator, garantindo que não ultrapasse o HP Máximo vindo dos Stats
	var max_hp = target.stats.hp.get_value()
	target.current_hp = int(min(max_hp, target.current_hp + amount))
	print("Curou %d de HP. HP atual: %d" % [amount, target.current_hp])
