extends Button

@export var menu_signals: MenuSignals

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(_on_button_up)

func _on_button_up():
	menu_signals.save_old_file.emit()
