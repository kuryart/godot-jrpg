## Generic class for [BattleActionDataItem] and [BattleActionDataSkill].
class_name BattleActionData extends Resource

## You also need a data variable in children.
func get_data():
	assert(false, "Must be implemented by child class.")
