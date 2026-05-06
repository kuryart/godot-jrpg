## The battler with this trait don't receive XP. 
##
## This class handles some traits from VX Ace Trait system.
## More info [url=https://rpgm.fandom.com/wiki/Traits]here[/url]
class_name TraitNoXp extends TraitFlag

func _init() -> void:
	type = Trait.TYPE.FLAG
	pass
