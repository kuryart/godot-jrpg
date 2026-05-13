class_name BattleMenuItems extends Control

@onready var items_grid: GridContainer = %ItemsGrid
@onready var messenger: RichTextLabel = %MessengerLabel
@onready var players_v_box: = %Players

@export var battle_signals: BattleSignals
@export var item_button: PackedScene
@export var player_button: PackedScene

var inventory: Inventory = GameManager.party.inventory
var item_to_use: Item = null

enum States { 
	ITEM_SELECTION,
	PLAYER_SELECTION
}
var current_state = States.ITEM_SELECTION

func _ready() -> void:
	battle_signals.item_clicked.connect(_on_item_clicked)
	battle_signals.item_changed.connect(_on_item_changed)
	battle_signals.battle_items_player_selected.connect(_on_player_selected)
	
	if inventory.items.is_empty(): return
	
	build_menu()
	lock_focus_boundaries()
	
	items_grid.get_child(0).grab_focus()

# ==========================================
# BUILD AND UI
# ==========================================
func build_menu():
	var inv_keys = inventory.items.keys()
	for current_item in inv_keys:
		var quantity = inventory.items[current_item]
		
		var item_button_instance = item_button.instantiate()
		items_grid.add_child(item_button_instance)
		
		item_button_instance.item = current_item
		item_button_instance.text = tr(current_item.display_name) + " x" + str(quantity)

func lock_focus_boundaries():
	var total_items = items_grid.get_child_count()
	
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
	
	for panel in players_v_box.get_children():
		var btn = panel.get_node("Button")
		btn.focus_neighbor_left = btn.get_path()

func refresh_item_list():
	for child in items_grid.get_children():
		child.queue_free()

	await get_tree().process_frame 
	build_menu()
	lock_focus_boundaries()

func get_button_for_item(target_item: Item) -> BattleItemButton:
	for child in items_grid.get_children():
		if child is ItemButton and child.item == target_item:
			return child
	return null

func go_to_player_selection():
	current_state = States.PLAYER_SELECTION
	var child_count = players_v_box.get_child_count()
	
	for i in range(child_count):
		var current_btn = players_v_box.get_child(i)
		
		if i == 0:
			current_btn.focus_neighbor_top = current_btn.get_path()
			current_btn.focus_neighbor_right = current_btn.get_path()
			current_btn.focus_neighbor_left = current_btn.get_path()
			current_btn.focus_neighbor_bottom = "" 
		elif i == child_count - 1: 
			current_btn.focus_neighbor_top = ""
			current_btn.focus_neighbor_right = current_btn.get_path()
			current_btn.focus_neighbor_left = current_btn.get_path()
			current_btn.focus_neighbor_bottom = current_btn.get_path()
		else:
			current_btn.focus_neighbor_top = ""
			current_btn.focus_neighbor_right = current_btn.get_path()
			current_btn.focus_neighbor_left = current_btn.get_path()
			current_btn.focus_neighbor_bottom = "" 
	
	var first_player_button = players_v_box.get_child(0)
	first_player_button.grab_focus()

# ==========================================
# ITEM USE FLOW
# ==========================================
func use_items_in_all_players(item: Item):
	for player in GameManager.party.players:
		apply_items_effect(item, player)

	consume_item_and_update_ui(item)

# ==========================================
# CONSUME AND EFFECTS
# ==========================================
func apply_items_effect(item: Item, target: Player):
	item.use(target)
	if item.effects != null:
		for effect in item.effects.effects:
			effect.apply(target)

func consume_item_and_update_ui(item: Item):
	current_state = States.ITEM_SELECTION
	if not item.is_consumable:
		var btn = get_button_for_item(item)
		if btn: btn.grab_focus()
		item_to_use = null
		return

	inventory.items[item] -= 1
	
	if inventory.items[item] <= 0:
		inventory.items.erase(item)
		item_to_use = null

		await refresh_item_list()
		if items_grid.get_child_count() > 0:
			items_grid.get_child(0).grab_focus()
	else:
		var btn = get_button_for_item(item)
		if btn:
			btn.text = tr(item.display_name) + " x" + str(inventory.items[item])
			btn.grab_focus()
		
		item_to_use = null

# ==========================================
# CANCEL ACTION
# ==========================================
func handle_back() -> bool:
	if current_state == States.PLAYER_SELECTION:
		cancel_player_selection()
		return true
	
	return false

func cancel_player_selection():
	current_state = States.ITEM_SELECTION
	if item_to_use != null:
		var btn = get_button_for_item(item_to_use)
		if btn: 
			btn.grab_focus()
		item_to_use = null
		
# ==========================================
# CONNECTED METHODS
# ==========================================
func _on_item_changed(item):
	messenger.text = tr(item.description)

func _on_player_selected(target: Player):
	if item_to_use == null: return

	apply_items_effect(item_to_use, target)
	consume_item_and_update_ui(item_to_use)

func _on_item_clicked(item: Item, _id_in_inventory: int):
	if inventory.items.is_empty() or not inventory.items.has(item): return

	if item.used_on == Item.USED_ON.MAP:
		print("Can't use this item in battle, only in menu.")
		Audio.play_sfx(Audio.sfx_bank_ui.bank["cancel"])
		return

	item_to_use = item
	
	var scope = item.targets.scope
	var side = item.targets.side

	# --- 1. MULTIPLE TARGETS (SCOPE.ALL) ---
	if scope == Target.Scope.ALL:
		if side == Target.Side.ALLIES:
			use_items_in_all_players(item)
		elif side == Target.Side.ENEMIES:
			battle_signals.item_used_on_all_enemies.emit(item)
		return

	# --- 2. SINGLE TARGET (SCOPE.ONE) ---
	if side == Target.Side.ALLIES or side == Target.Side.SELF:
		go_to_player_selection()
	elif side == Target.Side.ENEMIES:
		battle_signals.item_requires_enemy_target.emit(item)
