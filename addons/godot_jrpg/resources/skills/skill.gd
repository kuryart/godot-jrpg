class_name Skill extends Resource

enum USED_ON {MAP, BATTLE, BOTH}

@export var display_name: String
@export var description: String
@export var used_on: USED_ON
@export var effects: EffectList
@export var targets: Target
@export var message: String
@export var icon: Texture2D
@export var mp_cost: int
## Optional VFX played on each target when the skill is used in battle.
@export var vfx: VFX

## Apply effects to a target.
func apply_effects(target: Battler, attacker: Battler = null, engine: BattleEngine = null) -> void:
	print("[Skill] Executing effect of: ", display_name)

	if effects != null and effects.entries != null:
		for effect in effects.entries:
			if effect != null:
				effect.apply(target, attacker, engine)

## Consumes MP.
func pay_cost(user: Battler) -> void:
	if mp_cost > 0:
		print("[Skill] Consuming ", mp_cost, " MP from ", user.name)
		user.current_mp -= mp_cost
		user.current_mp = max(user.current_mp, 0)
