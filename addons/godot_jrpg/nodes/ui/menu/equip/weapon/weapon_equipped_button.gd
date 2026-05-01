class_name WeaponEquippedButton extends UIButton

@export var menu_signals: MenuSignals

var weapon: Weapon

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	button_up.connect(_on_button_up)
	
func _on_focus_entered():
	menu_signals.weapon_equipped_button_entered.emit(weapon)

func _on_button_up():
	super()
	menu_signals.weapon_equipped_button_up.emit(weapon)
