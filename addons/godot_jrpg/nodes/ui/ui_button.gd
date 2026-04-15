class_name UIButton extends BaseButton

func _ready() -> void:
	button_up.connect(_on_button_up)
	focus_exited.connect(_on_focus_exited)

func _on_button_up():
	Audio.play_sfx(Audio.sfx_bank_ui.bank["select"])

func _on_focus_exited():
	if Audio.is_sound_canceled:
		return
	
	Audio.play_sfx(Audio.sfx_bank_ui.bank["cursor"])
