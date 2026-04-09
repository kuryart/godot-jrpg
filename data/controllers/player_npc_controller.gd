class_name PlayerNPCController extends PlayerController

@export var brain: Brain

var engine: BattleEngine

func setup(_engine: BattleEngine, _handler: BattleInputHandler, _actor: BattleBattler) -> void:
	engine = _engine

func think() -> void:
	if engine.current_phase is BattlePhaseInit:
		BattleInputStartBattle.new().resolve(engine)
