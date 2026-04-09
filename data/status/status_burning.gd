class_name StatusBurning extends Status

@export var damage_percentage: float = 0.1 

func resolve(actor: BattleBattler):
	var max_hp = actor.stats.hp.get_value()
	var damage = int(max_hp * damage_percentage) 
	
	actor.current_hp -= damage 
	print("%s sofreu %d de dano de queimadura!" % [actor.data.name, damage])
