class_name PlayerManualController extends PlayerController

@export var input_assignment: InputAssignment

var engine: BattleEngine
var handler: BattleInputHandler
var actor: Battler

func setup(_engine: BattleEngine, _handler: BattleInputHandler, _actor: Battler):
	engine = _engine
	handler = _handler
	actor = _actor
	handler.action_pressed.connect(_on_action_pressed)
	handler.cancel_pressed.connect(_on_cancel_pressed)
	engine.battle_signals.fight_button_up.connect(_on_fight_button_up)
	engine.battle_signals.player_selected.connect(_on_player_selected)
	engine.battle_signals.attack_button_up.connect(_on_attack_button_up)
	engine.battle_signals.defend_button_up.connect(_on_defend_button_up)
	engine.battle_signals.items_button_up.connect(_on_items_button_up)
	engine.battle_signals.skills_button_up.connect(_on_skills_button_up)
	engine.battle_signals.enemy_button_up.connect(_on_enemy_button_up)

func _on_action_pressed():
	if engine.current_phase is BattlePhaseInit and engine.leader == actor and engine.current_phase.is_finished:
		BattleInputStartBattle.new().resolve(engine)
	elif engine.current_phase is BattlePhaseItemTarget and engine.leader == actor:
		var phase := engine.current_phase as BattlePhaseItemTarget
		if Target.is_target_scope_all(phase.targets.scope) and Target.is_target_side_allies(phase.targets.side):
			engine.battle_signals.all_allies_confirmed_emitted.emit()
		elif Target.is_target_scope_all(phase.targets.scope) and Target.is_target_side_enemies(phase.targets.side):
			engine.battle_signals.all_enemies_confirmed_emitted.emit()
		elif Target.is_target_side_self(phase.targets.side):
			engine.battle_signals.self_target_confirmed_emitted.emit()
	elif engine.current_phase is BattlePhaseSkillTarget and engine.leader == actor:
		var phase := engine.current_phase as BattlePhaseSkillTarget
		if Target.is_target_scope_all(phase.targets.scope) and Target.is_target_side_allies(phase.targets.side):
			engine.battle_signals.all_skill_allies_confirmed_emitted.emit()
		elif Target.is_target_scope_all(phase.targets.scope) and Target.is_target_side_enemies(phase.targets.side):
			engine.battle_signals.all_skill_enemies_confirmed_emitted.emit()
		elif Target.is_target_side_self(phase.targets.side):
			engine.battle_signals.self_skill_target_confirmed_emitted.emit()

func _on_cancel_pressed():
	engine.current_phase.handle_cancel(engine)

func _on_fight_button_up():
	if engine.current_phase is BattlePhaseSelection and engine.leader == actor:
		BattleInputPlayersMenu.new().resolve(engine)
		
func _on_player_selected(player: Player):
	if engine.leader != actor:
		return
	if engine.current_phase is BattlePhasePlayers:
		BattleInputFightMenu.new().resolve(engine)
	elif engine.current_phase is BattlePhaseItemTarget:
		var targets: Array[Battler] = [player]
		BattleInputPlayerSelect.new(targets).resolve(engine)
	elif engine.current_phase is BattlePhaseSkillTarget:
		var targets: Array[Battler] = [player]
		BattleInputPlayerSelect.new(targets).resolve(engine)

func _on_attack_button_up():
	if engine.current_phase is BattlePhaseFight:
		BattleInputAttack.new().resolve(engine)

func _on_defend_button_up():
	if engine.current_phase is BattlePhaseFight:
		BattleInputDefend.new().resolve(engine)

func _on_items_button_up():
	if engine.current_phase is BattlePhaseFight:
		BattleInputItems.new().resolve(engine)

func _on_skills_button_up():
	if engine.current_phase is BattlePhaseFight:
		BattleInputSkills.new().resolve(engine)

func _on_enemy_button_up(target_enemy: Enemy):
	if engine.leader == actor:
		if engine.current_phase is BattlePhaseAttackTarget or \
		   engine.current_phase is BattlePhaseItemTarget or \
		   engine.current_phase is BattlePhaseSkillTarget:

			var targets: Array[Battler] = [target_enemy]
			BattleInputEnemySelect.new(targets).resolve(engine)
