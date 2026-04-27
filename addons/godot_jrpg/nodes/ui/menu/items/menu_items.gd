extends Control

@onready var items: Array[Node]
@onready var item_button:= preload("res://objects/items/item_button.tscn")
@onready var items_grid:= get_node("%Options")
@onready var item_sprite:= get_node("%ItemSprite")
@onready var item_description:= get_node("%ItemDescription")

@export var  inventory: Inventory = preload("res://data/items/inventory.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.item_clicked.connect(_on_item_clicked)
	GameEvents.item_changed.connect(_on_item_changed)
	
	MenuManager.register_menu(self)
	for i in range(inventory.items.size()):
		var item_button_instance = item_button.instantiate()
		items_grid.add_child(item_button_instance)
		var inventory_items = inventory.items[i]
		item_button_instance.item = inventory_items
		item_button_instance.id_in_inventory = i
		item_button_instance.text = tr(inventory_items.name)
		
		print(tr(inventory_items.name))
		
		if i == 0 or i == 1:
			item_button_instance.focus_neighbor_top = item_button_instance.get_path()
		if i == inventory.items.size() -1 or i == inventory.items.size() - 2:
			item_button_instance.focus_neighbor_bottom = item_button_instance.get_path()
		if i % 2 == 0:
			item_button_instance.focus_neighbor_left = item_button_instance.get_path()
		else:
			item_button_instance.focus_neighbor_right = item_button_instance.get_path()	
	
	if inventory.items.size() == 0: return
	
	items = items_grid.get_children()
	items_grid.get_child(0).grab_focus()
	
func _exit_tree():
	MenuManager.unregister_menu(self)
	
func _on_item_clicked (item: Item, id_in_inventory: int):
	if inventory.items.size() == 0: return
	
	var target_item = items[id_in_inventory]
	items.remove_at(id_in_inventory)
	inventory.items.remove_at(id_in_inventory)
	target_item.queue_free()
	
	if inventory.items.size() == 0:
		item_sprite.texture = null
		item_description.text = ""
		return
	
	for i in range(items.size()):
		define_neighbors(i)
		items[i].text = inventory.items[i].name

	if not items.is_empty():
		items[0].grab_focus()

func define_neighbors(i):
	var current = items[i]
	
	# Clear neighbors
	current.id_in_inventory = i
	current.focus_neighbor_top = ""
	current.focus_neighbor_bottom = ""
	current.focus_neighbor_left = ""
	current.focus_neighbor_right = ""
	
	# If first line
	if i == 0 or i == 1:
		current.focus_neighbor_top = current.get_path()
	
	# If last line
	if i == items.size() -1 or i == items.size() - 2:
		current.focus_neighbor_bottom = current.get_path()
	
	# If even, then left. If odd, then right.
	if i % 2 == 0:
		current.focus_neighbor_left = current.get_path()
	else:
		current.focus_neighbor_right = current.get_path()
	if items.size() == 1:
		current.focus_neighbor_right = current.get_path()

func _on_item_changed(item):
	item_sprite.texture = item.sprite
	item_description.text = tr(item.description)
