class_name Stats extends Resource

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
