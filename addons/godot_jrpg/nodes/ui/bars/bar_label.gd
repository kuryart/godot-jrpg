class_name BarLabel extends Label

func setup(value: int, change_signal: Signal):
	text = str(value)
	change_signal.connect(_on_value_changed)

func _on_value_changed(new_val: int):
	text = str(new_val)
