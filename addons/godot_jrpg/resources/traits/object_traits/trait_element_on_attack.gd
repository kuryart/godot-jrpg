class_name TraitElementOnAttack extends TraitObject

@export var element: Element

func apply() -> Element:
	return element

func _to_string() -> String:
	var element_name = element.name if element else "None"
	return "[Trait:ELEM_ATK | %s]" % element_name
