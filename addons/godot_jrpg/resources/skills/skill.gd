class_name Skill extends Resource

enum USED_ON {MAP, BATTLE, BOTH}

@export var display_name: String
@export var description: String
@export var used_on: USED_ON
@export var effects: EffectList
@export var targets: Target
@export var damage: FormulaSkillDamage
@export var message: String
@export var icon: Texture
@export var mp_cost: int

@warning_ignore("unused_parameter")
func use(target):
	print("[Skill] Executing effect of: ", display_name)
