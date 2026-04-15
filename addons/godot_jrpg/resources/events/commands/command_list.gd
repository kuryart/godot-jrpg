class_name CommandList extends Resource

@export var commands: Array[Command] = []

func add_command(command: Command) -> CommandList:
	commands.append(command)
	return self
