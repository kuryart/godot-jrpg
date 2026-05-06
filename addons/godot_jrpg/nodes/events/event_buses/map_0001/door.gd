extends Node

@export var dialogue: DialogueResource

func _on_event_fired():
	var flow = CommandList.new()
	flow.add_command(CommandStartDialogue.create(dialogue))
	EventRunner.run(flow)
