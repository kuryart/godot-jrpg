extends Node

@export var battle_settings: BattleSettings
@export var fade_pattern: Texture2D

func _on_event_fired():
	var flow = CommandList.new()
	flow.add_command(CommandStartBattle.create(battle_settings, fade_pattern))
	EventRunner.run(flow)
