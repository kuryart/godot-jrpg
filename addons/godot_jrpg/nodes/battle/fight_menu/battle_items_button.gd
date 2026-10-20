class_name BattleItemsButton extends UIButton

@export var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

var item: Item

func _ready():
	button_up.connect(_on_button_up)
	
func _on_button_up():
	super()
	battle_signals.items_button_up.emit()
	battle_signals.toggle_menu_items_emitted.emit(true)
