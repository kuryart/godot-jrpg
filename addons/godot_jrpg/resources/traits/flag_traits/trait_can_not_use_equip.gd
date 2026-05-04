## The battler can't use determined [Skill]
##
## This class handles some traits from VX Ace Trait system.
## More info [url=https://rpgm.fandom.com/wiki/Traits]here[/url]
class_name TraitCanNotUseEquip extends TraitObject

@export var equip: ItemEquippable

func _to_string() -> String:
	return "[Trait:CAN'T USE EQUIP | %s]" % [equip.display_name]
