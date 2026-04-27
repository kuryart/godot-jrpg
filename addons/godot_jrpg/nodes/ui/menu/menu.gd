class_name Menu extends Control

@export var menu_items_scene: PackedScene
@export var menu_skills_scene: PackedScene
@export var menu_equip_scene: PackedScene
@export var menu_status_scene: PackedScene
@export var menu_save_scene: PackedScene

@export var menu_signals: MenuSignals

var menu: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_signals.open_menu_status_emited.connect(_on_status_button_up)
	menu_signals.open_menu_save_emited.connect(_on_save_button_up)
	MenuManager.register_menu(self)

func _exit_tree():
	MenuManager.unregister_menu(self)

func _on_items_button_up():
	open_menu_items()
	
func _on_skills_button_up():
	open_menu_skills()
	
func _on_equip_button_up():
	open_menu_equip()
	
func _on_status_button_up():
	open_menu_status()
	
func _on_save_button_up():
	open_menu_save()

func open_menu_items():
	menu = menu_items_scene.instantiate()
	get_tree().root.add_child(menu)

func open_menu_skills():
	menu = menu_skills_scene.instantiate()
	get_tree().root.add_child(menu)

func open_menu_equip():
	menu = menu_equip_scene.instantiate()
	get_tree().root.add_child(menu)

func open_menu_status():
	menu = menu_status_scene.instantiate()
	get_tree().root.add_child(menu)

func open_menu_save():
	menu = menu_save_scene.instantiate()
	get_tree().root.add_child(menu)
