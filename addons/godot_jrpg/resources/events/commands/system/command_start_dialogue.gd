class_name CommandStartDialogue extends Command

var dialogue: DialogueResource

static func create(_dialogue: DialogueResource) -> CommandStartDialogue:
	var cmd = CommandStartDialogue.new()
	cmd.is_wait = true
	cmd.dialogue = _dialogue
	return cmd

func resolve():
	print("[CommandStartDialogue]: Starting dialoogue.")
	GameManager.change_game_state(GameManager.GameStates.DIALOGUE)
	await DialogueManager.show_dialogue_balloon(dialogue).tree_exited
	GameManager.get_back_to_last_game_state()
	finished.emit()
