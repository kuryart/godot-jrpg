class_name BattlePlayerUI extends BattleBattlerUI

@onready var hp_bar: Bar = get_node("%HPBar")
@onready var mp_bar: Bar = get_node("%MPBar")
@onready var current_hp_label: BarLabel = get_node("%CurrentHP")
@onready var current_mp_label: BarLabel = get_node("%CurrentMP")

var engine: BattleEngine
var player: Player

func _init() -> void:
	focus_entered.connect(_on_focus_entered)

func setup(_engine: BattleEngine, _player: Player):
	engine = _engine
	player = _player
	if not is_node_ready(): await ready
	hp_bar.setup(player.stats.hp.get_value(), player.current_hp, player.hp_changed)
	mp_bar.setup(player.stats.mp.get_value(), player.current_mp, player.mp_changed)
	current_hp_label.setup(player.current_hp, player.hp_changed)
	current_mp_label.setup(player.current_mp, player.mp_changed)

func _on_button_up():
	super()
	engine.battle_signals.player_selected.emit()

func _on_focus_entered():
	engine.battle_signals.player_changed.emit(player)
