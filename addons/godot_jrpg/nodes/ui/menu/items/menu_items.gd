class_name MenuItems extends Control

@onready var items_grid:= %ItemsGrid
@onready var item_description:= %ItemDescription
@onready var players_v_box: = %Players

@export var menu_signals: MenuSignals
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
	menu_signals.item_clicked.connect(_on_item_clicked)
	menu_signals.item_changed.connect(_on_item_changed)
	menu_signals.menu_items_player_selected.connect(_on_player_selected)
	
	MenuManager.register_menu(self)
	
	if inventory.items.is_empty(): return
	
	build_menu()
	instantiate_players()
	lock_focus_boundaries()
	
	items_grid.get_child(0).grab_focus()
	
func _exit_tree():
	MenuManager.unregister_menu(self)

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

func instantiate_players():
	var players = GameManager.party.players
	for player in players:
		var player_instance = player_button.instantiate()
		
		var player_face: TextureRect = player_instance.get_node("%Face")
		player_face.texture = player.face
		
		var p_button: MenuItemsPlayerButton = player_instance.get_node("Button")
		p_button.player = player
		
		players_v_box.add_child(player_instance)

func lock_focus_boundaries():
	var total_items = items_grid.get_child_count()
	
	for i in range(total_items):
		var btn = items_grid.get_child(i)
		
		btn.focus_neighbor_right = ""
		btn.focus_neighbor_left = ""
		btn.focus_neighbor_top = ""
		btn.focus_neighbor_bottom = ""
		
		if i % 2 != 0 or i == total_items - 1:
			btn.focus_neighbor_right = btn.get_path()
			
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

func get_button_for_item(target_item: Item) -> ItemButton:
	for child in items_grid.get_children():
		if child is ItemButton and child.item == target_item:
			return child
	return null

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
	item_description.text = tr(item.description)

func _on_player_selected(target: Player):
	if item_to_use == null: return

	apply_items_effect(item_to_use, target)
	consume_item_and_update_ui(item_to_use)

func _on_item_clicked(item: Item, _id_in_inventory: int):
	if inventory.items.is_empty() or not inventory.items.has(item): return

	if item.used_on == Item.USED_ON.BATTLE:
		print("Can't use this item on menu, only in battle.")
		return

	if item.targets != null and item.targets.scope == Target.Scope.ALL:
		use_items_in_all_players(item)
		return

	item_to_use = item
	current_state = States.PLAYER_SELECTION
	var first_player_panel = players_v_box.get_child(0)
	first_player_panel.get_node("Button").grab_focus()
