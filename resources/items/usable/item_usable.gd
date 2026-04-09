class_name ItemUsable extends Item

enum USED_ON {MAP, BATTLE, BOTH}

@export var is_consumable: bool = true
@export var used_on: USED_ON

@warning_ignore("unused_parameter")
func use(target):
	print("[ItemUsable] Executando efeito de: ", display_name)
	# Lógica de efeito (cura, buff, etc)
