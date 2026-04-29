class_name TitleMenu extends Control

# Buttons
@onready var new_game_button = %NewGame
@onready var load_game_button = %LoadGame
@onready var settings_button = %Settings
@onready var exit_button = %Exit

@export var settings_scene: PackedScene
@export var load_scene: PackedScene
@export var first_map: PackedScene

var menu: Node

func _ready() -> void:
	UI.set_ui_lock(true)
	await Fade.fade_in(4.0).finished
	UI.set_ui_lock(false)
	
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	load_game_button.pressed.connect(_on_load_game_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	MenuManager.register_menu(self)
	
	new_game_button.grab_focus()

func _exit_tree() -> void:
	MenuManager.unregister_menu(self)

func _on_new_game_button_pressed():
	UI.set_ui_lock(true)
	await Fade.fade_out(4.0).finished
	var command_list = CommandList.new()
	var command_change_scene = CommandChangeScene.create(first_map)
	command_list.add_command(command_change_scene)
	EventRunner.run(command_list)
	GameManager.change_game_state(GameManager.GameStates.MAP)
	await Fade.fade_in(4.0).finished

func _on_load_game_button_pressed():
	menu = load_scene.instantiate()
	get_tree().root.add_child(menu)

func _on_settings_button_pressed():
	menu = settings_scene.instantiate()
	get_tree().root.add_child(menu)

func _on_exit_button_pressed():
	get_tree().quit()
