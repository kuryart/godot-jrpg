class_name AccessoryEquipButton extends UIButton

@export var menu_signals: MenuSignals

var accessory: Accessory
var quantity: int

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	button_up.connect(_on_button_up)
	
func _on_focus_entered():
	menu_signals.accessory_equip_button_entered.emit(accessory)
	
func _on_button_up():
	super()
	menu_signals.accessory_equip_button_up.emit(accessory)
