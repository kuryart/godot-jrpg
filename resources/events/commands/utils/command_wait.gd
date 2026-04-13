class_name CommandWait extends Command

@export var duration: float = 1.0

static func create(_duration: float) -> CommandWait:
	var cmd = CommandWait.new()
	cmd.duration = _duration
	cmd.is_wait = true
	return cmd

func resolve() -> void:
	print("[CommandWait] Starting wait for %s seconds." % duration)
	await Director.instance.get_tree().create_timer(duration).timeout
	print("[CommandWait] Wait finished.")
	finished.emit()
