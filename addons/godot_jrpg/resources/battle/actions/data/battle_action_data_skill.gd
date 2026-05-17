class_name BattleActionDataSkill extends BattleActionData

var data: Skill

func _init(skill: Skill) -> void:
	data = skill

func get_data() -> Skill:
	return data
