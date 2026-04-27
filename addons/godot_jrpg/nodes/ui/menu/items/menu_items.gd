class_name MenuItems extends Control

@onready var items: Array[Node]
@onready var items_grid:= get_node("%Options")
@onready var item_sprite:= get_node("%ItemSprite")
@onready var item_description:= get_node("%ItemDescription")

@export var menu_signals: MenuSignals
@export var item_button: PackedScene
@export var inventory: Inventory

func _ready() -> void:
	menu_signals.item_clicked.connect(_on_item_clicked)
	menu_signals.item_changed.connect(_on_item_changed)
	
	MenuManager.register_menu(self)
	
	var inv_keys = inventory.items.keys()
	
	for i in range(inv_keys.size()):
		var current_item = inv_keys[i]
		var quantity = inventory.items[current_item]
		
		var item_button_instance = item_button.instantiate()
		items_grid.add_child(item_button_instance)
		
		item_button_instance.item = current_item
		item_button_instance.id_in_inventory = i
		
		item_button_instance.text = tr(current_item.name) + " x" + str(quantity)
		
		if i == 0 or i == 1:
			item_button_instance.focus_neighbor_top = item_button_instance.get_path()
		if i == inv_keys.size() -1 or i == inv_keys.size() - 2:
			item_button_instance.focus_neighbor_bottom = item_button_instance.get_path()
		if i % 2 == 0:
			item_button_instance.focus_neighbor_left = item_button_instance.get_path()
		else:
			item_button_instance.focus_neighbor_right = item_button_instance.get_path()   
	
	if inventory.items.is_empty(): return
	
	items = items_grid.get_children()
	items_grid.get_child(0).grab_focus()
	
func _exit_tree():
	MenuManager.unregister_menu(self)
	
func _on_item_clicked(item: Item, id_in_inventory: int):
	if inventory.items.is_empty() or not inventory.items.has(item): return
	
	inventory.items[item] -= 1
	
	if inventory.items[item] <= 0:
		inventory.items.erase(item)
		
		var target_item = items[id_in_inventory]
		items.remove_at(id_in_inventory)
		target_item.queue_free()
		
		if inventory.items.is_empty():
			item_sprite.texture = null
			item_description.text = ""
			return
		
		var updated_keys = inventory.items.keys()
		
		for i in range(items.size()):
			define_neighbors(i)
			var current = updated_keys[i]
			var qty = inventory.items[current]
			
			items[i].item = current
			items[i].text = tr(current.name) + " x" + str(qty)

		if not items.is_empty():
			items[0].grab_focus()
			
	else:
		items[id_in_inventory].text = tr(item.name) + " x" + str(inventory.items[item])

func define_neighbors(i):
	var current = items[i]
	var total_items = items.size()
	
	current.id_in_inventory = i
	current.focus_neighbor_top = ""
	current.focus_neighbor_bottom = ""
	current.focus_neighbor_left = ""
	current.focus_neighbor_right = ""
	
	if i == 0 or i == 1:
		current.focus_neighbor_top = current.get_path()
		
	if i == total_items -1 or i == total_items - 2:
		current.focus_neighbor_bottom = current.get_path()
		
	if i % 2 == 0:
		current.focus_neighbor_left = current.get_path()
	else:
		current.focus_neighbor_right = current.get_path()
		
	if total_items == 1:
		current.focus_neighbor_right = current.get_path()

func _on_item_changed(item):
	item_sprite.texture = item.sprite
	item_description.text = tr(item.description)
