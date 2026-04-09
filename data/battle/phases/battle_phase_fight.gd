class_name BattlePhaseFight extends BattlePhase

var player

func _init() -> void:
	resource_name = "Fight"

func resolve(engine: BattleEngine):
	engine.change_to_battler(player)
	engine.go_to_fight_menu()
	player = null
	
func set_player(_player: BattlePlayer):
	player = _player
