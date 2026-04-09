## Class that describes info for a player. It's like a player character sheet.
class_name Player extends Battler

## The player's face used in battle and menus.
@export var face: CompressedTexture2D
## The player's level.
@export var level: int = 1
## The player's current xp.
@export var xp: int = 0
## The player's class.
@export var player_class: PlayerClass
## The formula used to calculate the necessary xp required to achieve a certain level.
@export var xp_formula: FormulaXP

## Signal emited when player level up.
signal leveled_up(new_level: int)

## Adds an amount of xp to player.
func add_xp(amount: int):
	xp += amount
	check_level_up()

## Checks if the player leveled up by earning xp.
func check_level_up():
	var xp_formula_param = FormulaXPParameter.new()
	xp_formula_param.level = level
	var required = xp_formula.calculate(xp_formula_param)
	
	while xp >= required:
		level += 1
		xp -= required
		update_base_stats()
		leveled_up.emit(level)
		print("[Battler] %s subiu para o nível %d!" % [name, level])
		required = xp_formula.get_value(level + 1)

## Updates the stats when the battler level up. It uses a [FormulaStatGrowthParameter] 
## to give flexibility to the rules for updating stats. Learn more at [Formula] and [StatGrowth].
func update_base_stats():
	var param = FormulaStatGrowthParameter.new()
	param.level = level
	
	# --- HP ---
	param.base_stat_value = stats.hp.base_value
	stats.hp.base_value = player_class.hp_growth.calculate(param)
	# --- MP ---
	param.base_stat_value = stats.mp.base_value
	stats.mp.base_value = player_class.mp_growth.calculate(param)
	# --- Attack ---
	param.base_stat_value = stats.attack.base_value
	stats.attack.base_value = player_class.attack_growth.calculate(param)
	# --- Defense ---
	param.base_stat_value = stats.defense.base_value
	stats.defense.base_value = player_class.defense_growth.calculate(param)
	# --- Intelligence ---
	param.base_stat_value = stats.intelligence.base_value
	stats.intelligence.base_value = player_class.intelligence_growth.calculate(param)
	# --- Speed ---
	param.base_stat_value = stats.speed.base_value
	stats.speed.base_value = player_class.speed_growth.calculate(param)
	# --- Accuracy ---
	param.base_stat_value = stats.accuracy.base_value
	stats.accuracy.base_value = player_class.accuracy_growth.calculate(param)
	# --- Evasion ---
	param.base_stat_value = stats.evasion.base_value
	stats.evasion.base_value = player_class.evasion_growth.calculate(param)
	# --- Luck ---
	param.base_stat_value = stats.luck.base_value
	stats.luck.base_value = player_class.luck_growth.calculate(param)
