class_name EventSignals extends Resource

@warning_ignore_start("unused_signal")
signal battle_requested(settings: BattleSettings)
signal scene_change_requested(scene_path: String)
signal dialogue_requested(lines: Array[String])
