class_name EffectDamage extends Effect

@export var damage_formula: FormulaEffectDamage
@export var chance_formula: FormulaEffectChance
@export var critical_chance_formula: FormulaEffectCriticalChance
@export var is_critical: bool = false

func apply(target: Battler, attacker: Battler = null, engine: BattleEngine = null):
	if engine == null or attacker == null:
		return
	if chance_formula != null and engine.is_effect_missed(self, attacker, target):
		print("[EffectDamage] Effect missed ", target.name)
		return
	var damage = engine.damage_calculator.calculate_effect_damage(self, attacker, target, engine)
	target.take_damage(damage)
