extends Node

@export var battle_settings: BattleSettings

func _on_event_fired():
	var flow = CommandList.new()
	flow.add_command(CommandStartBattle.create(battle_settings))
	EventRunner.run(flow)
