## This class controls stats modifications.
class_name StatModifier extends Resource

## The name of the modified stat.
@export var id: StringName
## The value to be multiplied.
@export var value_multiply: float = 0.0
## The value to be added.
@export var value_add: int = 0.0
## The duration in turns of the stat modification. -1 is forever.
@export var duration: int = -1

func _init(_id: StringName = &"", _value_multiply: float = 1.0, _value_add: int = 0, _duration: int = -1) -> void:
	id = _id
	value_multiply = _value_multiply
	value_add = _value_add
	duration = _duration
