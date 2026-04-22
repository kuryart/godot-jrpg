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
## The hp regeneration rate
@export var hp_regen: Stat
## The mp regeneration rate
@export var mp_regen: Stat
## The critical chance rate
@export var critical: Stat
## The critical dodge chance rate
@export var critical_dodge: Stat
## The magical dodge chance rate
@export var magical_dodge: Stat
## The reflection (skill) chance rate
@export var reflection: Stat
## The counter-attack (attack) chance rate
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
		&"hp": hp,
		&"mp": mp,
		&"attack": attack,
		&"defense": defense,
		&"intelligence": intelligence,
		&"speed": speed,
		&"accuracy": accuracy,
		&"evasion": evasion,
		&"luck": luck
	}

## Returns all stats.
func get_all_stats() -> Array[Stat]:
	if stat_map.is_empty():
		initialize_stat_map()
	return stat_map.values()
