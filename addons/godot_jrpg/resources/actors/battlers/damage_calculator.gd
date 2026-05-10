class_name DamageCalculator extends Resource

## Formula used to calculate hit physical damage.
@export var physical_damage_formula: FormulaDamage
## Formula used to calculate critical hit damage.
@export var critical_damage_formula: FormulaCriticalDamage

## Calculate the physical damage.
func calculate_physical_damage(attacker: Battler, defender: Battler, engine: BattleEngine) -> int:
	var param = FormulaDamageParameter.new()
	param.attacker = attacker
	param.defender = defender
	var damage: float = float(physical_damage_formula.calculate(param))
	damage = get_modified_damage(attacker, defender, damage)
	damage = get_elemental_damage(attacker, defender, damage)
	damage = get_critical_damage(attacker, defender, damage, engine)
	return int(max(damage, 0))

## Calculate the critical damage.
func calculate_critical_damage(damage: int) -> int:
	var param = FormulaCriticalDamageParameter.new()
	var critical_multiplier = critical_damage_formula.calculate(param)
	return int(critical_multiplier * damage)

func get_critical_damage(attacker: Battler, defender: Battler, damage: int, engine: BattleEngine) -> int:
	if engine.is_attack_critical(attacker, defender):
		var crit_damage = calculate_critical_damage(int(damage))
		damage = int(crit_damage)
		print("[BattleEngine] ", attacker.name, " dealt critical damage to ", defender.name)
	return damage

func get_elemental_damage(attacker: Battler, defender: Battler, damage: int) -> int:
	if not attacker.elements.is_empty():
		for element in attacker.elements:
			damage = attacker.trait_aggregator.get_elemental_damage_dealt_modified(element, damage)
			damage = defender.trait_aggregator.get_elemental_damage_received_modified(element, damage)
	return damage

func get_modified_damage(attacker: Battler, defender: Battler, damage: int) -> int:
	damage = attacker.trait_aggregator.get_damage_dealt_modified(damage)
	damage = defender.trait_aggregator.get_damage_received_modified(damage)
	return damage
