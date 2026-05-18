## Used to call business logic in an event.
##
## This is simply a gdscript file. You can create your own logic here. You can use
## commands like [CommandWait] or [CommandStartBattle], and can use gdscript's 
## if/else, while, for, or anything godot have.
extends EventBus

## The script can have variables.
@export var example_var: String = "Hello world!"

## When the event is triggered, this is called.
func _on_event_fired():
	# Create a command list.
	var flow = CommandList.new()
	# Add commands.
	flow.add_command(CommandWait.create(1.0))
	# Event runner will run all the commands in the list.
	EventRunner.run(flow)
