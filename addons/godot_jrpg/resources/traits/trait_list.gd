class_name TraitList extends Resource

## A collection of traits that can be attached to some database object.
@export var entries: Array[Trait] = []

## Helper to quickly filter traits by type without manual loops elsewhere
func get_traits_of_type(target_class: GDScript) -> Array:
	return entries.filter(func(t): return is_instance_of(t, target_class))
