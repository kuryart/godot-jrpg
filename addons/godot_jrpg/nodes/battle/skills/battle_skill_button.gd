class_name BattleSkillButton extends UIButton

@export var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

var skill: Skill

func _ready() -> void:
	button_up.connect(_on_button_up)
	focus_entered.connect(_on_focus_entered)

func _on_button_up():
	battle_signals.skill_clicked.emit(skill)

func _on_focus_entered():
	battle_signals.skill_changed.emit(skill)
