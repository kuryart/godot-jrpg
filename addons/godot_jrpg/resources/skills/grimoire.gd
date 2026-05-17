class_name Grimoire extends Resource

@export var skills: Array[Skill] = []

func add_skill(skill: Skill) -> void:
	if not has_skill(skill):
		skills.append(skill)

func remove_skill(skill: Skill) -> void:
	skills.erase(skill)

func has_skill(skill: Skill) -> bool:
	return skills.has(skill)
