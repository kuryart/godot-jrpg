class_name SkillButton extends UIButton

@export var menu_signals: MenuSignals

var skill: Skill

func _ready() -> void:
	button_up.connect(_on_button_up)
	focus_entered.connect(_on_focus_entered)

func _on_button_up():
	menu_signals.skill_clicked.emit(skill)

func _on_focus_entered():
	menu_signals.skill_changed.emit(skill)
