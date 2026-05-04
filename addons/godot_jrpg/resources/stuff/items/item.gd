class_name Item extends Stuff

enum USED_ON {MAP, BATTLE, BOTH}

@export var is_consumable: bool = true
@export var used_on: USED_ON
@export var effects: EffectList
@export var traits: TraitList
@export var targets: Target

@warning_ignore("unused_parameter")
func use(target):
	print("[ItemUsable] Executing effect of: ", display_name)
