class_name BattleActionDataItem extends BattleActionData

var data: Item

func _init(item: Item) -> void:
	data = item

func get_data() -> Item:
	return data
