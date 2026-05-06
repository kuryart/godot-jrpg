extends Button

@export var menu_signals: MenuSignals

func _ready() -> void:
	button_up.connect(_on_button_up)

func _on_button_up():
	menu_signals.save_new_file_emited.emit()
