class_name CommandStartBattle extends Command

@export var settings: BattleSettings

static func create(_settings: BattleSettings) -> CommandStartBattle:
	var cmd = CommandStartBattle.new()
	cmd.settings = _settings
	cmd.is_wait = true
	return cmd

func resolve():
	print("[CommandStartBattle] Starting battle.")
	var director = Director.instance
	var map = director.current_scene
	director.remove_child(map)
	var battle_scene = load("uid://bgyg5l0h0l00g").instantiate()
	director.add_child(battle_scene)
	await director.get_tree().process_frame
	battle_scene.initialize(settings)
	await battle_scene.battle_finished
	battle_scene.queue_free()
	director.add_child(map)
	await director.get_tree().process_frame
	print("[CommandStartBattle] Finished battle.")
	finished.emit()
