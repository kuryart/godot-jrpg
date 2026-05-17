class_name BattleMenuItems extends PanelContainer

@onready var items_grid: GridContainer = %ItemsGrid
@onready var messenger: RichTextLabel = %MessengerLabel

@export var battle_signals: BattleSignals
@export var item_button: PackedScene
@export var player_button: PackedScene

## Reference to the battle engine, injected via signal.
var battle_engine: BattleEngine = null
var inventory: Inventory = GameManager.party.inventory
var item_to_use: Item = null

enum States { 
	ITEM_SELECTION,
	TARGET_SELECTION
}
var current_state = States.ITEM_SELECTION

func _ready() -> void:
	battle_signals.item_changed.connect(_on_item_changed)
	battle_signals.engine_initialized.connect(_on_engine_initialized)
	battle_signals.item_clicked.connect(_on_item_clicked)
	build_menu()

# ==========================================
# BUILD AND UI
# ==========================================
## Builds the menu, automatically evaluating the class-level battle_engine for shadowing.
func build_menu() -> void:
	var inv_keys = inventory.items.keys()
	
	for current_item in inv_keys:
		var actual_quantity: int = inventory.items[current_item]
		var queued_quantity: int = 0
		
		if battle_engine != null:
			queued_quantity = battle_engine.get_queued_item_count(current_item)
		if item_to_use == current_item:
			queued_quantity += 1

		var available_quantity: int = actual_quantity - queued_quantity

		if available_quantity > 0:
			var item_button_instance: BattleItemButton = item_button.instantiate()
			item_button_instance.item = current_item
			items_grid.add_child(item_button_instance)
			item_button_instance.text = tr(current_item.display_name) + " x" + str(available_quantity)

func lock_focus_boundaries():
	var total_items = items_grid.get_child_count()
	
	if total_items == 0: return 
	
	for i in range(total_items):
		var btn: Button = items_grid.get_child(i)
		
		btn.focus_neighbor_right = ""
		btn.focus_neighbor_left = ""
		btn.focus_neighbor_top = ""
		btn.focus_neighbor_bottom = ""
		
		if i % 2 != 0 or i == total_items - 1:
			btn.focus_neighbor_right = btn.get_path()
		
		if i % 2 == 0:
			btn.focus_neighbor_left = btn.get_path()
			
		if i < 2:
			btn.focus_neighbor_top = btn.get_path()
			
		if i + 2 >= total_items:
			btn.focus_neighbor_bottom = btn.get_path()

func refresh_item_list() -> void:
	item_to_use = null
	current_state = States.ITEM_SELECTION

	for child in items_grid.get_children():
		items_grid.remove_child(child)
		child.queue_free()

	build_menu()
	lock_focus_boundaries()

	if is_visible_in_tree() and items_grid.get_child_count() > 0:
		items_grid.get_child(0).grab_focus()

func get_button_for_item(target_item: Item) -> BattleItemButton:
	for child in items_grid.get_children():
		if child is BattleItemButton and child.item == target_item:
			return child
	return null

# ==========================================
# CANCEL ACTION
# ==========================================
func handle_back() -> bool:
	if current_state == States.TARGET_SELECTION:
		cancel_target_selection()
		return true
	
	return false

func cancel_target_selection():
	var cancelled_item = item_to_use
	refresh_item_list()
	if cancelled_item != null:
		var btn = get_button_for_item(cancelled_item)
		if btn:
			btn.grab_focus()
		
# ==========================================
# CONNECTED METHODS
# ==========================================
func _on_item_changed(item):
	messenger.text = tr(item.description)

func _on_item_clicked(item: Item):
	if item.used_on == Item.USED_ON.MAP:
		return
	item_to_use = item
	current_state = States.TARGET_SELECTION

## Callback triggered when the engine broadcasts its reference.
func _on_engine_initialized(engine: BattleEngine) -> void:
	battle_engine = engine
	print(battle_engine)
