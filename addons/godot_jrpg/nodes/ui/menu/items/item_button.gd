class_name ItemButton extends UIButton

@export var menu_signals: MenuSignals

var item: Item
var id_in_inventory: int
var icon: Texture

func resolve():
	pass

func _ready() -> void:
	button_up.connect(_on_button_up)
	focus_entered.connect(_on_focus_entered)

func _on_button_up():
	menu_signals.item_clicked.emit(item, id_in_inventory)

func _on_focus_entered():
	menu_signals.item_changed.emit(item)
