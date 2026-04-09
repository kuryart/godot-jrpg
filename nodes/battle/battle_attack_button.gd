class_name BattleAttackButton extends UIButton

@export var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

func _ready():
	button_up.connect(_on_button_up)
	
func _on_button_up():
	super()
	battle_signals.attack_button_up.emit()
