class_name PlayerManualController extends PlayerController

@export var input_assignment: InputAssignment

var engine: BattleEngine
var handler: BattleInputHandler
var actor: BattleBattler

func setup(_engine: BattleEngine, _handler: BattleInputHandler, _actor: BattleBattler):
	engine = _engine
	handler = _handler
	actor = _actor
	handler.action_pressed.connect(_on_action_pressed)
	handler.cancel_pressed.connect(_on_cancel_pressed)
	engine.battle_signals.fight_button_up.connect(_on_fight_button_up)
	engine.battle_signals.player_selected.connect(_on_player_selected)
	engine.battle_signals.attack_button_up.connect(_on_attack_button_up)

func _on_action_pressed():
	if engine.current_phase is BattlePhaseInit and engine.leader == actor and engine.current_phase.is_finished:
		BattleInputStartBattle.new().resolve(engine)

func _on_cancel_pressed():
	engine.current_phase.handle_cancel(engine)

func _on_fight_button_up():
	if engine.current_phase is BattlePhaseSelection and engine.leader == actor:
		BattleInputPlayersMenu.new().resolve(engine)
		
func _on_player_selected():
	if engine.current_phase is BattlePhasePlayers:
		BattleInputFightMenu.new().resolve(engine)

func _on_attack_button_up():
	if engine.current_phase is BattlePhaseFight:
		BattleInputAttack.new().resolve(engine)
