class_name Stats extends Resource

@export var hp: Stat
@export var mp: Stat
@export var attack: Stat
@export var defense: Stat
@export var intelligence: Stat
@export var speed: Stat
@export var accuracy: Stat
@export var evasion: Stat
@export var luck: Stat

# Facilitador para o Jupyter e Logs
func to_dict() -> Dictionary:
	return {
		"hp": hp.get_value(),
		"mp": mp.get_value(),
		"attack": attack.get_value(),
		"defense": defense.get_value(),
		"intelligence": intelligence.get_value(),
		"speed": speed.get_value(),
		"accuracy": accuracy.get_value(),
		"evasion": evasion.get_value(),
		"luck": luck.get_value()
	}
