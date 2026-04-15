class_name CommandChangeFace extends Command

static func create(_duration: float) -> CommandChangeFace:
	var cmd = CommandChangeFace.new()
	cmd.is_wait = true
	return cmd

func resolve() -> void:
	pass
