class_name BattleItemButton extends UIButton

@export var battle_signals: BattleSignals

var item: Item
var id_in_inventory: int
var icon: Texture

func resolve():
	pass

func _ready() -> void:
	button_up.connect(_on_button_up)
	focus_entered.connect(_on_focus_entered)
	battle_signals.items_button_up.connect(_on_items_button_up)

func _on_button_up():
	battle_signals.item_clicked.emit(item, id_in_inventory)

func _on_focus_entered():
	battle_signals.item_changed.emit(item)

func _on_items_button_up():
	grab_focus()
