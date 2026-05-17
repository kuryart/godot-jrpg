## Class for the usable or passive items.
##
## - If the item have and effect, it's active, an can be consumable.
## [br]- If the item don't have an effect, it's passive. It can have traits to define the passive effects.
## It can also be consumable, but it will have no effect.
## [br]- If the item have an effect and a trait, it is both passive and active, and can be consumable.
## [br]- If the item don't have neither an effect and a trait... well, it's useless.
class_name Item extends Stuff

## Enum to define where the item can be used.
enum USED_ON {
			MAP, ## The item can be used in map. 
			BATTLE, ## The item can be used in battle.
			BOTH ## The item can be used both in map and in battle.
			}
## Refers to the enum that define where the item can be used.
@export var used_on: USED_ON
## Is this item consumable? If it is consumable, it will vanish after use. Otherwise, it will stand in inventory.
@export var is_consumable: bool = true
## The effects for the item. If it have effects, it is an active item. If not, it is a passive item.
@export var effects: EffectList
## The traits for the item. This can be used in passive items.
@export var traits: TraitList
## The targets for the item. It can be, one or all; and enemies, or allies, or both. See [Target] for more
## information.
@export var targets: Target

## Apply effect for a single target.
func apply_effects(target: Battler, attacker: Battler = null, engine: BattleEngine = null) -> void:
	print("[ItemUsable] Executing effect of: ", display_name)

	if effects != null and effects.entries != null:
		for effect in effects.entries:
			if effect != null:
				effect.apply(target, attacker, engine)

## Consume the item, removing it from inventory.
func consume() -> void:
	if not is_consumable:
		return
	
	var inventory: Inventory = GameManager.party.inventory
	
	if inventory.items.has(self):
		inventory.items[self] -= 1
		
		if inventory.items[self] <= 0:
			inventory.items.erase(self)
