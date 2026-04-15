class_name Bar extends ProgressBar

func setup(max_val: int, current_val: int, change_signal: Signal):
	max_value = max_val
	value = current_val
	# Connects dinamically to the signal given (either hp_changed or mp_changed)
	change_signal.connect(_on_value_changed)

func _on_value_changed(new_val: int):
	var tween = create_tween()
	tween.tween_property(self, "value", new_val, 0.4).set_trans(Tween.TRANS_SINE)
