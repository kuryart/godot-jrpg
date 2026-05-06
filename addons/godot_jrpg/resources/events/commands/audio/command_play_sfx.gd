class_name CommandPlaySFX extends Command

@export var sfx: SFX
@export_range(-80.0, 6.0) var volume_db: float = 0.0
@export_range(-0.01, 4.0) var pitch_scale: float = 1.0

static func create(_sfx: SFX, _vol: float = 0.0, _pitch: float = 1.0, _wait: bool = false) -> CommandPlaySFX:
	var cmd = CommandPlaySFX.new()
	cmd.sfx = _sfx
	cmd.volume_db = _vol
	cmd.pitch_scale = _pitch
	cmd.is_wait = _wait
	return cmd

## Play SFX
func resolve():
	print("[CommandPlaySFX] Starting SFX.")
	Audio.play_sfx(sfx)
	print("[CommandPlaySFX] Finished SFX.")
	finished.emit()
