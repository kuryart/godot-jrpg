class_name Map extends Node2D

@export var player_spawn: Vector2 = Vector2.ZERO

func _ready() -> void:
	GameManager.change_game_state(GameManager.GameStates.MAP)
	_spawn_player()

func _spawn_player() -> void:
	if not GameManager.map_player:
		push_error("[Map] GameManager.map_player is not set.")
		return
	var player = GameManager.map_player.instantiate()
	add_child(player)
	if GameManager.has_pending_position():
		player.position = GameManager.pop_pending_player_position()
	else:
		player.position = player_spawn
	var phantom_cam = get_node_or_null("%PhantomCamera2D")
	if phantom_cam:
		phantom_cam.set("follow_target", player)
