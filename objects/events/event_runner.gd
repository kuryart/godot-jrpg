class_name EventRunner extends Node

func run(command_list: CommandList):
	for command in command_list.commands:
		if command.is_wait:
			@warning_ignore("redundant_await")
			command.resolve()
			await command.finished
		else:
			command.resolve()
