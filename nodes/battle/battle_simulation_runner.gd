class_name BattleSimulationRunner extends SceneTree

# Configurações da Simulação
const NUM_SIMULATIONS = 1000
const OUTPUT_PATH = "user://simulation_results.json"

func _init():
	var all_results = []
	print("Iniciando %d simulações..." % NUM_SIMULATIONS)
	
	for i in range(NUM_SIMULATIONS):
		var result = run_single_battle(i)
		all_results.append(result)
		
		if i % 100 == 0:
			print("Progresso: %d/%d" % [i, NUM_SIMULATIONS])
			
	save_massive_log(all_results)
	print("Simulações concluídas. Arquivo salvo em: ", ProjectSettings.globalize_path(OUTPUT_PATH))
	quit()

func run_single_battle(id: int) -> Dictionary:
	# Aqui instanciamos o Manager de forma efêmera para cada batalha
	var manager = load("res://objects/autoloads/battle_manager.gd").new()
	
	# Criamos Battlers fictícios (ou carregamos de .tres)
	var player = create_mock_battler("Hero", true)
	var enemy = create_mock_battler("Slime", false)
	
	manager.setup_simulation([player, enemy])
	manager.run_full_simulation()
	
	var data = manager.get_summary() # Método que retorna o ganhador e turnos
	data["sim_id"] = id
	return data

func create_mock_battler(actor_name: String, is_player: bool) -> Battler:
	# 1. Criamos os Stats individuais
	var s = Stats.new()
	s.hp = Stat.new(); s.hp.base_value = 100
	s.mp = Stat.new(); s.mp.base_value = 50
	s.attack = Stat.new(); s.attack.base_value = 20
	s.defense = Stat.new(); s.defense.base_value = 10
	s.intelligence = Stat.new(); s.intelligence.base_value = 15
	s.speed = Stat.new(); s.speed.base_value = 15
	
	# 2. Criamos o recurso de Battler (Player ou Enemy)
	@warning_ignore("incompatible_ternary")
	var res = Player.new() if is_player else Enemy.new()
	res.name = actor_name
	res.stats = s
	
	# 3. Instanciamos o Controller
	var ctrl_path = "res://data/battle/controllers/player_ai_controller.gd" if is_player else "res://data/battle/controllers/enemy_ai_controller.gd"
	var ctrl = load(ctrl_path).new()

	# 4. Agora passamos os 2 argumentos esperados pelo Battler._init
	var actor = Battler.new(res, ctrl)
	actor.is_player = is_player # Define o lado para o filtro funcionar
	return actor

func save_massive_log(data: Array):
	var file = FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
