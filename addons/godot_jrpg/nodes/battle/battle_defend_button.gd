class_name BattleDefendButton extends UIButton

@export var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

func _ready():
	button_up.connect(_on_button_up)
	
func _on_button_up():
	super()
	battle_signals.defend_button_up.emit()
