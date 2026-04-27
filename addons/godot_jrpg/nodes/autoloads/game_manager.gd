extends Node

enum GameStates {INTRO, TITLE, MAP, MAP_ACT, MENU, BATTLE, BATTLE_ACT, DIALOGUE, GAME_OVER}
var game_state: GameStates = GameStates.INTRO
var last_game_state: GameStates = GameStates.INTRO

enum Languages {EN,PT,ES}
@export var language: Languages = Languages.PT

enum Difficulties {HARD, NIGHTMARE, HELL}
@export var difficulty: Difficulties = Difficulties.HARD

var can_open_menu: bool = false

func change_game_state(state: GameStates):
	last_game_state = game_state
	game_state = state
	match_game_state()

func match_game_state():
	match game_state:
		GameStates.INTRO:
			can_open_menu = false
		GameStates.TITLE:
			can_open_menu = false
		GameStates.MAP:
			can_open_menu = true
		GameStates.MAP_ACT:
			can_open_menu = false
		GameStates.MENU:
			can_open_menu = false
		GameStates.BATTLE:
			can_open_menu = false
		GameStates.BATTLE_ACT:
			can_open_menu = false
		GameStates.DIALOGUE:
			can_open_menu = false
		GameStates.GAME_OVER:
			can_open_menu = false
