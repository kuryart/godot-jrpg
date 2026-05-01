class_name ArmorEquippedButton extends UIButton

@export var menu_signals: MenuSignals

var armor: Armor

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	button_up.connect(_on_button_up)
	
func _on_focus_entered():
	menu_signals.armor_equipped_button_entered.emit(armor)

func _on_button_up():
	super()
	menu_signals.armor_equipped_button_up.emit(armor)
