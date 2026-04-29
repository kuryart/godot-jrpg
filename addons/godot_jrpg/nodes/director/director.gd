class_name Director extends Node

static var instance: Director

@export var is_testing: bool = true
@export var event_signals: EventSignals

@export var party: Party
@export var steps_walked: int = 0

# Cenas
@export_category("Scenes")
# Cenas Reais
@export_group("Real Scenes")
@export var splash_screen: PackedScene
@export var title_menu: PackedScene
@export var map: PackedScene
@export var battle: PackedScene
@export_group("Test Scenes")
# Cenas de Teste (Mocks)
@export var test_splash_screen: PackedScene
@export var test_title_menu: PackedScene
@export var test_map: PackedScene
@export var test_battle: PackedScene

var current_scene: Node

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	if is_testing:
		print("[Director] Modo de teste ativado")
		run_flow()
		#run_test_flow()

func run_flow():
	var flow = CommandList.new()
	# Splash
	flow.add_command(CommandChangeScene.create(splash_screen))
	flow.add_command(CommandWait.create(2.0))
	await EventRunner.run(flow)

func run_test_flow():
	var flow = CommandList.new()
	# Splash
	flow.add_command(CommandChangeScene.create(test_splash_screen))
	flow.add_command(CommandWait.create(2.0))
	# Menu
	flow.add_command(CommandChangeScene.create(test_title_menu))
	flow.add_command(CommandWait.create(2.0))
	# Mapa
	flow.add_command(CommandChangeScene.create(test_map))
	flow.add_command(CommandWait.create(2.0))
	# Batalha
	var battle_settings = load("uid://caggj6rpows4p")
	flow.add_command(CommandStartBattle.create(battle_settings))

	await EventRunner.run(flow)

func replace_scene(new_scene: Node):
	if current_scene:
		current_scene.queue_free()
	current_scene = new_scene
	add_child(current_scene)
