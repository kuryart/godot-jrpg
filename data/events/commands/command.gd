class_name Command extends Resource

@export var is_wait: bool = true

@warning_ignore("unused_signal")
signal finished

## Abstract method for resolving commands. Overwrite in the child classes.
func resolve() -> void:
	pass
