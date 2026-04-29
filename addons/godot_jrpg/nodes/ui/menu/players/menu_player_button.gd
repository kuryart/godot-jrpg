class_name MenuPlayerButton extends Button

@export var menu_signals: MenuSignals

var player: Player

func _ready() -> void:
	button_up.connect(_on_button_up)
	
func _on_button_up():
	menu_signals.player_selected.emit(player)
