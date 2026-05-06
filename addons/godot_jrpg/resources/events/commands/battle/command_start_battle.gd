class_name CommandStartBattle extends Command

@export var settings: BattleSettings
@export var fade_pattern: Texture2D

static func create(_settings: BattleSettings, fade_pattern: Texture2D = null) -> CommandStartBattle:
	var cmd = CommandStartBattle.new()
	cmd.settings = _settings
	cmd.is_wait = true
	return cmd

func resolve():
	print("[CommandStartBattle] Starting battle.")
	await Fade.fade_out(2.0, Color(0,0,0,1), fade_pattern, false, true).finished
	var director = Director.instance
	var map = director.current_scene
	director.remove_child(map)
	var battle_scene = load("uid://bgyg5l0h0l00g").instantiate()
	director.add_child(battle_scene)
	await director.get_tree().process_frame
	battle_scene.initialize(settings)
	await Fade.fade_in(2.0, Color(0,0,0,1), fade_pattern, false, true).finished
	await battle_scene.battle_finished
	battle_scene.queue_free()
	director.add_child(map)
	await director.get_tree().process_frame
	print("[CommandStartBattle] Finished battle.")
	finished.emit()
