extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(_on_button_up)

func _on_button_up():
	GameEvents.emit_signal("save_new_file")
