## Inspired by RPG Maker traits.
##
## This class controls passive effects into [Player], [PlayerClass], [Weapon], 
## [Armor], [Accessory], [Shield], [Head], [Status] and [Enemy].
@abstract class_name Trait extends Resource

enum TYPE {
		DAMAGE_RECEIVED, DAMAGE_DEALT, STAT, EQUIPMENT, STATUS_CHANCE, 
		STATUS_IMMUNITY
	}

var type: TYPE
