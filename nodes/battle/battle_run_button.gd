class_name BattleRunButton extends UIButton

@export var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

func _ready():
	button_up.connect(_on_button_up)
	focus_entered.connect(_on_focus_entered)
	
func _on_button_up():
	super()
	battle_signals.run_button_up.emit()

func _on_focus_entered():
	battle_signals.run_button_entered.emit()
