class_name EffectStatModifier extends Effect

@export var stat_name: String = "attack" # hp, attack, defense, intelligence, speed, etc.
@export var modifier: StatModifier

func apply(target: Battler):
	# Acessa o stat dinamicamente pelo nome
	var stat_obj = target.stats.get(stat_name)
	if stat_obj is Stat:
		stat_obj.add_modifier(modifier)
		print("Aplicou modificador %s em %s" % [modifier.name, stat_name])
