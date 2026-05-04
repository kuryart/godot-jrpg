class_name Menu extends Control

@onready var players_container: VBoxContainer = %Players
@onready var first_button: Button = %Items

@export var menu_items_scene: PackedScene
@export var menu_skills_scene: PackedScene
@export var menu_equip_scene: PackedScene
@export var menu_status_scene: PackedScene
@export var menu_save_scene: PackedScene
@export var menu_player_scene: PackedScene

@export var menu_signals: MenuSignals

enum MENU_STATES {MENU, EQUIP, STATUS}
var menu_state

var menu: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	MenuManager.register_menu(self)
	menu_state = MENU_STATES.MENU
	instantiate_players()
	first_button.grab_focus()

func _exit_tree():
	MenuManager.unregister_menu(self)

func connect_signals():
	menu_signals.open_menu_status_emited.connect(_on_status_button_up)
	menu_signals.open_menu_save_emited.connect(_on_save_button_up)
	menu_signals.open_menu_equip_emited.connect(_on_equip_button_up)
	menu_signals.open_menu_items_emited.connect(_on_items_button_up)
	menu_signals.menu_player_selected.connect(_on_player_selected)

func instantiate_players():
	var players = GameManager.party.players
	for player in players:
		var player_instance = menu_player_scene.instantiate()
		var player_face: TextureRect = player_instance.get_node("%Face")
		player_face.texture = player.face
		var player_button: MenuPlayerButton = player_instance.get_child(0)
		player_button.player = player
		players_container.add_child(player_instance)

func go_to_players_menu():
	players_container.get_child(0).get_child(0).grab_focus()

# --- Open functions ---
func open_menu_items():
	menu = menu_items_scene.instantiate()
	get_tree().root.add_child(menu)

func open_menu_skills():
	menu = menu_skills_scene.instantiate()
	get_tree().root.add_child(menu)

func open_menu_equip(player: Player):
	menu = menu_equip_scene.instantiate()
	menu.player = player
	get_tree().root.add_child(menu)

func open_menu_status(player: Player):
	menu = menu_status_scene.instantiate()
	menu.player = player
	get_tree().root.add_child(menu)

func open_menu_save():
	menu = menu_save_scene.instantiate()
	get_tree().root.add_child(menu)

# --- Connected functions ---
func _on_items_button_up():
	open_menu_items()
	
func _on_skills_button_up():
	open_menu_skills()
	
func _on_equip_button_up():
	menu_state = MENU_STATES.EQUIP
	go_to_players_menu()
	
func _on_status_button_up():
	menu_state = MENU_STATES.STATUS
	go_to_players_menu()
	
func _on_save_button_up():
	open_menu_save()

func _on_player_selected(player: Player):
	if menu_state == MENU_STATES.EQUIP:
		open_menu_equip(player)
	elif menu_state == MENU_STATES.STATUS:
		open_menu_status(player)
