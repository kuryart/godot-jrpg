extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_all_party_traits()

func debug_all_party_traits() -> void:
	# Ajuste 'members' para a variável real que guarda os atores na sua classe Party
	var party_members = GameManager.party.players 
	
	for player in party_members:
		if not player is Player: continue
			
		print("==================================================")
		print("🧠 INSPECIONANDO TRAITS DE: ", player.name)
		print("==================================================")
		
		# 1. Traits do próprio Battler
		_print_traits_from_source(player.traits, "Battler Base")
		
		# 2. Traits da Classe e Equipamentos
		if player.player_class != null:
			_print_traits_from_source(player.player_class.traits, "Class: " + player.player_class.name)
			
			var equip = player.equip
			if equip.weapon.item != null:
				_print_traits_from_source(equip.weapon.item.traits, "Weapon: " + equip.weapon.item.display_name)
			if equip.armor.item != null:
				_print_traits_from_source(equip.armor.item.traits, "Armor: " + equip.armor.item.display_name)
			if equip.accessory.item != null:
				_print_traits_from_source(equip.accessory.item.traits, "Accessory: " + equip.accessory.item.display_name)
			if equip.head.item != null:
				_print_traits_from_source(equip.head.item.traits, "Head: " + equip.head.item.display_name)
			if equip.shield.item != null:
				_print_traits_from_source(equip.shield.item.traits, "Shield: " + equip.shield.item.display_name)
				
		# 3. Traits vindos de Status Ativos
		for status: Status in player.status:
			if status != null:
				_print_traits_from_source(status.traits, "Status: " + status.name)
		
		print("\n")

## Helper para varrer a TraitList e imprimir os dados formatados
func _print_traits_from_source(trait_list: TraitList, origin_name: String) -> void:
	if trait_list == null or trait_list.entries.is_empty():
		return
		
	print("  📍 Origem: %s" % origin_name)
	
	for t in trait_list.entries:
		if t == null: continue
		
		# Tenta extrair o nome do script GDScript (ex: trait_status_chance_attack.gd)
		var script_name = "Built-in Trait"
		if t.get_script() != null:
			script_name = t.get_script().resource_path.get_file().get_basename()
			
		# Imprime o nome do arquivo da classe e depois os dados variáveis
		# O str(t) vai invocar automaticamente o _to_string() que você definiu nas suas classes
		print("      ↳ [%s] %s" % [script_name, str(t)])
