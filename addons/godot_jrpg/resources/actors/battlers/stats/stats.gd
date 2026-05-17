## This class holds all stats for a battler. 
##
## You can simply use the resource already created in resources/actors/battlers/stats/stats.tres to 
## quickly set all stats for a battler, but remember to duplicate the resource, otherwise it will be 
## shared by two or more battlers, which is not the expected behaviour. You can create new stats and
## place them here, but you will have to implement the logic for it in the game. You can also remove
## a stat, but this can break the system - if you know what you're doing, go ahead.
class_name Stats extends Resource

@export_group("Main Stats")
## The stat used for HP.
@export var hp: Stat
## The stat used for MP.
@export var mp: Stat
## The stat used for Attack.
@export var attack: Stat
## The stat used for Defense.
@export var defense: Stat
## The stat used for Intelligence.
@export var intelligence: Stat
## The stat used for Speed.
@export var speed: Stat
## The stat used for Accuracy.
@export var accuracy: Stat
## The stat used for Evasion.
@export var evasion: Stat
## The stat used for Luck.
@export var luck: Stat

@export_group("Other Stats")
## The hp regeneration rate. This stat is a percentage. Values greater than 100 will be considered 100.
@export var hp_regen: Stat
## The mp regeneration rate. This stat is a percentage. Values greater than 100 will be considered 100.
@export var mp_regen: Stat
## The critical chance rate. This stat is a percentage. Values greater than 100 will be considered 100.
@export var critical: Stat
## The critical dodge chance rate. This stat is a percentage. Values greater than 100 will be considered 100.
@export var critical_dodge: Stat
## The magical dodge chance rate. This stat is a percentage. Values greater than 100 will be considered 100.
@export var effect_dodge: Stat
## The reflection (skill) chance rate. This stat is a percentage. Values greater than 100 will be considered 100.
@export var reflection: Stat
## The counter-attack (attack) chance rate. This stat is a percentage. Values greater than 100 will be considered 100.
@export var counter_attack: Stat

## Internal cache for searches by name.
var stat_map: Dictionary = {}

## Returns stat corresponding by name (ex: &"Attack")
func get_stat_by_name(stat_name: StringName) -> Stat:
	if stat_map.is_empty():
		initialize_stat_map()
	return stat_map.get(stat_name)

## Maps Stats to its IDs.
func initialize_stat_map() -> void:
	stat_map = {
		## Main stats
		&"hp": hp,
		&"mp": mp,
		&"attack": attack,
		&"defense": defense,
		&"intelligence": intelligence,
		&"speed": speed,
		&"accuracy": accuracy,
		&"evasion": evasion,
		&"luck": luck,
		# Other stats
		&"hp_regen": hp_regen,
		&"mp_regen": mp_regen,
		&"critical": critical,
		&"critical_dodge": critical_dodge,
		&"effect_dodge": effect_dodge,
		&"reflection": reflection,
		&"counter_attack": counter_attack,
	}

## Returns all stats.
func get_all_stats() -> Array[Stat]:
	if stat_map.is_empty():
		initialize_stat_map()
	return stat_map.values()
