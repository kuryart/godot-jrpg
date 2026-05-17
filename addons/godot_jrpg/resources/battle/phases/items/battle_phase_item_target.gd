class_name BattlePhaseItemTarget extends BattlePhase

var item: Item
var targets: Target
var effects: EffectList

func _init(_item: Item) -> void:
	resource_name = "ItemTarget"
	targets = _item.targets
	effects = _item.effects
	item = _item

func resolve(engine: BattleEngine):
	if Target.is_target_side_allies(targets.side):
		if Target.is_target_scope_one(targets.scope):
			select_one_ally(engine)
		elif Target.is_target_scope_all(targets.scope):
			select_all_allies(engine)
	
	elif Target.is_target_side_enemies(targets.side):
		if Target.is_target_scope_one(targets.scope):
			select_one_enemy(engine)
		elif Target.is_target_scope_all(targets.scope):
			select_all_enemies(engine)

	elif Target.is_target_side_both(targets.side):
		if Target.is_target_scope_one(targets.scope):
			select_one_both(engine)
		elif Target.is_target_scope_all(targets.scope):
			select_all_both(engine)

	elif Target.is_target_side_self(targets.side):
		select_self(engine)

	elif Target.is_target_side_everyone(targets.side):
		select_everyone(engine)

func select_one_ally(engine: BattleEngine):
	engine.battle_signals.select_item_target_one_ally_emitted.emit(item)
	engine.battle_signals.go_to_players_menu_emitted.emit()
	
func select_all_allies(engine: BattleEngine):
	engine.battle_signals.select_item_target_all_allies_emitted.emit(item)

func select_one_enemy(engine: BattleEngine):
	engine.battle_signals.select_item_target_one_enemy_emitted.emit(item)

func select_all_enemies(engine: BattleEngine):
	engine.battle_signals.select_item_target_all_enemies_emitted.emit(item)

func select_one_both(engine: BattleEngine):
	engine.battle_signals.select_item_target_one_both_emitted.emit(item)

func select_all_both(engine: BattleEngine):
	engine.battle_signals.select_item_target_all_both_emitted.emit(item)

func select_self(engine: BattleEngine):
	engine.battle_signals.select_item_target_self_emitted.emit(item)

func select_everyone(engine: BattleEngine):
	engine.battle_signals.select_item_target_everyone_emitted.emit(item)

func handle_cancel(engine: BattleEngine):
	engine.battle_signals.enemies_focus_mode_changed.emit(Control.FOCUS_NONE)
	engine.battle_signals.players_focus_mode_changed.emit(Control.FOCUS_NONE)
	BattleInputItems.new().resolve(engine)
