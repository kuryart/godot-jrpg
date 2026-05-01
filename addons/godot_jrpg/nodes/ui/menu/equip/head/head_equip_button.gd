class_name HeadEquipButton extends UIButton

@export var menu_signals: MenuSignals

var head: Head
var quantity: int

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	button_up.connect(_on_button_up)
	
func _on_focus_entered():
	menu_signals.head_equip_button_entered.emit(head)
	
func _on_button_up():
	super()
	menu_signals.head_equip_button_up.emit(head)
