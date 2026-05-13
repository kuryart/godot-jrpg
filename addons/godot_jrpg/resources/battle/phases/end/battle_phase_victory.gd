class_name BattlePhaseVictory extends BattlePhase

func _init() -> void:
	resource_name = "Victory"

func resolve(engine: BattleEngine):
	await engine.get_tree().create_timer(1.5).timeout
	engine.clear_focus()
	engine.battle_signals.toggle_messenger_emited.emit(true)
	engine.battle_signals.message_emited.emit("Victory!")
	await engine.get_tree().create_timer(1.5).timeout
	
	var total_xp: int = 0
	var total_money: int = 0
	var dropped_items: Array[Stuff] = []

	for enemy in engine.enemies:
		total_xp += enemy.xp
		total_money += enemy.money

		for loot in enemy.loot:
			if randf() <= loot.chance:
				dropped_items.append(loot.item)
				
	var party: Party = engine.battle_settings.party

	if total_money > 0:
		party.add_money(total_money)
		engine.battle_signals.message_emited.emit("Earned %d %s." % [total_money, GameManager.money_name])
		await engine.get_tree().create_timer(1.5).timeout
	
	if total_xp > 0:
		engine.battle_signals.message_emited.emit("Party earned %d XP." % total_xp)
		await engine.get_tree().create_timer(1.5).timeout
		
		for player in engine.players:
			var can_gain_xp = not player.trait_aggregator.has_flag(TraitNoXp)
			
			if can_gain_xp:
				var old_level = player.level
				player.add_xp(total_xp)
				if player.level > old_level:
					engine.battle_signals.message_emited.emit("%s reached level %d!" % [player.name, player.level])
					await engine.get_tree().create_timer(1.5).timeout

	if not dropped_items.is_empty():
		for item in dropped_items:
			party.inventory.add_item(item, 1)
			
			engine.battle_signals.message_emited.emit("Found: %s!" % item.display_name)
			await engine.get_tree().create_timer(1.0).timeout

	engine.battle_signals.toggle_messenger_emited.emit(false)
	
	print("[BattlePhaseVictory] Battle finished.")
	engine.battle_signals.toggle_messenger_emited.emit(false)
	engine.battle_signals.inner_battle_ended.emit()
	
	end()
