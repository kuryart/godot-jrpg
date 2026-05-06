class_name CommandStartDialogue extends Command

var dialogue: DialogueResource

static func create(_dialogue: DialogueResource) -> CommandStartDialogue:
	var cmd = CommandStartDialogue.new()
	cmd.is_wait = true
	cmd.dialogue = _dialogue
	return cmd

func resolve():
	print("[CommandStartDialogue]: Starting dialoogue.")
	await DialogueManager.show_dialogue_balloon(dialogue)
	finished.emit()
