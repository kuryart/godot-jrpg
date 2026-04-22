extends Node

@export var battler_player: Player
@export var battler_enemy: Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	execute_traits()

func execute_traits():
	# --- Player ---
	battler_player.trait_aggregator.refresh()
	print(battler_player.trait_aggregator.traits_by_type)
