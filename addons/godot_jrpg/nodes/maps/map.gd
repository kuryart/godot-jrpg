class_name Map extends Node2D

func _ready() -> void:
	GameManager.change_game_state(GameManager.GameStates.MAP)
