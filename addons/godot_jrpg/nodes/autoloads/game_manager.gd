extends Node

enum GameStates {INTRO, TITLE, MAP, MAP_ACT, MENU, BATTLE, BATTLE_ACT, DIALOGUE, GAME_OVER}
var game_state: GameStates = GameStates.INTRO
var last_game_state: GameStates = GameStates.INTRO

enum Languages {EN,PT,ES}
@export var language: Languages = Languages.PT

enum Difficulties {HARD, NIGHTMARE, HELL}
@export var difficulty: Difficulties = Difficulties.HARD

@export var party: Party
@export var switches: Dictionary[String, Switch]
@export var money_name: String
@export var map_player: PackedScene

var steps_walked: int = 0
## The time played in seconds
var time_played: int = 0
var can_open_menu: bool = false
var can_act: bool = true
var pending_player_position: Vector2 = Vector2.ZERO
var _has_pending_player_position: bool = false

func change_game_state(state: GameStates):
	last_game_state = game_state
	game_state = state
	match_game_state()
	print("[GameManager] Current game state: ", game_state)
	print("[GameManager] Last game state: ", last_game_state)
	print("[GameManager] Can open menu: ", can_open_menu)
	print("[GameManager] Can act: ", can_act)

func get_back_to_last_game_state():
	change_game_state(last_game_state)

func match_game_state():
	match game_state:
		GameStates.INTRO:
			can_open_menu = false
		GameStates.TITLE:
			can_open_menu = false
		GameStates.MAP:
			can_open_menu = true
			can_act = true
		GameStates.MAP_ACT:
			can_open_menu = false
			can_act = false
		GameStates.MENU:
			can_open_menu = false
			can_act = false
		GameStates.BATTLE:
			can_open_menu = false
		GameStates.BATTLE_ACT:
			can_open_menu = false
		GameStates.DIALOGUE:
			can_open_menu = false
			can_act = false
		GameStates.GAME_OVER:
			can_open_menu = false

func pop_pending_player_position() -> Vector2:
	if not _has_pending_player_position:
		return Vector2.ZERO
	_has_pending_player_position = false
	return pending_player_position

func has_pending_position() -> bool:
	return _has_pending_player_position

func save_game(path: String):
	var save := SaveState.new()

	save.party = party
	save.switches = switches
	save.game_state = game_state
	save.last_game_state = last_game_state
	save.language = language
	save.difficulty = difficulty

	save.current_scene_path = get_tree().current_scene.scene_file_path

	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		save.player_position = players[0].position

	if path == "":
		path = save.get_next_save_path()

	save.write_save(path)
	
func load_game(path: String) -> void:
	var save = SafeResourceLoader.load(path) as SaveState

	if save == null:
		push_error("[GameManager]: Error loading save file: " + path)
		return

	party = save.party
	switches = save.switches
	game_state = save.game_state
	last_game_state = save.last_game_state
	language = save.language
	difficulty = save.difficulty

	pending_player_position = save.player_position
	_has_pending_player_position = true

	if save.current_scene_path != "":
		get_tree().change_scene_to_file(save.current_scene_path)
	
	print("[GameManager]: Game loaded.", path)
