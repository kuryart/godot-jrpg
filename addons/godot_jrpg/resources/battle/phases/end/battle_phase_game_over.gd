class_name BattlePhaseGameOver extends BattlePhase

var game_over_scene: PackedScene = preload("uid://dt4asa3fn4vxc")

func _init() -> void:
	resource_name = "GameOver"

func resolve(engine: BattleEngine):
	await engine.get_tree().create_timer(1.5).timeout
	await Fade.fade_out(4.0).finished
	var flow = CommandList.new()
	flow.add_command(CommandChangeScene.create(game_over_scene))
	EventRunner.run(flow)
	await Fade.fade_in(4.0).finished
