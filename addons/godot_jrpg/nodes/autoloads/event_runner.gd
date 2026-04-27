extends Node

func run(command_list: CommandList):
	for command in command_list.commands:
		if command.is_wait:
			command.resolve()
			await command.finished
		else:
			command.resolve()
