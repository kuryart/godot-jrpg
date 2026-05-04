class_name TraitElementOfAttack extends TraitObject

@export var element: Element

func _to_string() -> String:
	var element_name = element.name if element else "None"
	return "[Trait:ELEM_ATK | %s]" % element_name
