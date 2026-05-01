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
## The character equipment
@export var equip: EquipmentSlots

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

	for stat_name in ["hp", "mp", "attack", "defense", "intelligence", "speed", "accuracy", "evasion", "luck"]:
		var stat = stats.get_stat_by_name(stat_name)
		var growth_formula = player_class.get(stat_name + "_growth")
		param.base_stat_value = stat.base_value
		stat.level_growth_value = growth_formula.calculate(param)
