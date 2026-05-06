class_name MenuSkills extends Control

@onready var skills_grid:= %SkillsGrid
@onready var skill_description:= %SkillDescription
@onready var players_v_box: = %Players

@export var menu_signals: MenuSignals
@export var skill_button: PackedScene
@export var player_button: PackedScene
@export var caster: Player

var skill_to_use: Skill = null

enum States { 
	SKILL_SELECTION,
	PLAYER_SELECTION
}
var current_state = States.SKILL_SELECTION

func _ready() -> void:
	var cam = get_viewport().get_camera_2d()
	if cam:
		global_position = cam.get_screen_center_position() - (size / 2.0)
	menu_signals.skill_clicked.connect(_on_skill_clicked)
	menu_signals.skill_changed.connect(_on_skill_changed)
	menu_signals.menu_skills_player_selected.connect(_on_player_selected)
	
	MenuManager.register_menu(self)
	
	if caster.skills.is_empty(): return
	
	build_menu()
	instantiate_players()
	lock_focus_boundaries()
	
	skills_grid.get_child(0).grab_focus()
	
func _exit_tree():
	MenuManager.unregister_menu(self)

# ==========================================
# BUILD AND UI
# ==========================================
func build_menu():
	for current_skill in caster.skills:
		var skill_button_instance = skill_button.instantiate()
		skills_grid.add_child(skill_button_instance)
		
		skill_button_instance.skill = current_skill
		skill_button_instance.text = "%s (%d MP)" % [tr(current_skill.display_name), current_skill.mp_cost]

func instantiate_players():
	var players = GameManager.party.players
	for player in players:
		var player_instance = player_button.instantiate()
		
		var player_face: TextureRect = player_instance.get_node("%Face")
		player_face.texture = player.face

		var p_button: MenuSkillsPlayerButton = player_instance.get_node("Button")
		p_button.player = player
		
		players_v_box.add_child(player_instance)

func lock_focus_boundaries():
	var total_items = skills_grid.get_child_count()
	
	for i in range(total_items):
		var btn = skills_grid.get_child(i)
		
		btn.focus_neighbor_right = ""
		btn.focus_neighbor_left = ""
		btn.focus_neighbor_top = ""
		btn.focus_neighbor_bottom = ""
		
		if i % 2 != 0 or i == total_items - 1:
			btn.focus_neighbor_right = btn.get_path()
			
		if i < 2:
			btn.focus_neighbor_top = btn.get_path()
			
		if i + 2 >= total_items:
			btn.focus_neighbor_bottom = btn.get_path()
	
	for panel in players_v_box.get_children():
		var btn = panel.get_node("Button")
		btn.focus_neighbor_left = btn.get_path()

func get_button_for_skill(target_skill: Skill) -> SkillButton:
	for child in skills_grid.get_children():
		if child is SkillButton and child.skill == target_skill:
			return child
	return null

# ==========================================
# SKILL USE FLOW
# ==========================================
func _on_skill_clicked(skill: Skill):
	if skill.used_on == Skill.USED_ON.BATTLE:
		print("[Skill] This skill can't be used in menu.")
		Audio.play_sfx(Audio.sfx_bank_ui.bank["cancel"])
		return
		
	if caster.current_mp < skill.mp_cost:
		print("[Skill] You don't have necessary MP!")
		Audio.play_sfx(Audio.sfx_bank_ui.bank["cancel"])
		return

	# Sem alvo definido: usa no próprio caster
	if skill.targets == null:
		apply_skill_effect(skill, caster)
		consume_mp_and_update_ui(skill)
		return

	match skill.targets.side:
		Target.Side.ENEMIES:
			print("[Skill] Invalid target.")
			Audio.play_sfx(Audio.sfx_bank_ui.bank["cancel"])
			return
		Target.Side.SELF:
			apply_skill_effect(skill, caster)
			consume_mp_and_update_ui(skill)
			return
		_: # ALLIES or BOTH
			if skill.targets.scope == Target.Scope.ALL:
				use_skill_in_all_players(skill)
				return
			
			skill_to_use = skill
			current_state = States.PLAYER_SELECTION
			var first_player_panel = players_v_box.get_child(0)
			first_player_panel.get_node("Button").grab_focus()

func _on_player_selected(target: Player):
	if skill_to_use == null: return

	apply_skill_effect(skill_to_use, target)
	consume_mp_and_update_ui(skill_to_use)

func use_skill_in_all_players(skill: Skill):
	for player in GameManager.party.players:
		apply_skill_effect(skill, player)
	consume_mp_and_update_ui(skill)

# ==========================================
# CONSUME AND EFFECTS
# ==========================================
func apply_skill_effect(skill: Skill, target: Player):
	skill.use(target)
	if skill.effects != null:
		for effect in skill.effects.effects:
			effect.apply(target)

func consume_mp_and_update_ui(skill: Skill):
	current_state = States.SKILL_SELECTION
	caster.current_mp -= skill.mp_cost

	var btn = get_button_for_skill(skill)
	if btn: 
		btn.grab_focus()
	
	skill_to_use = null
	
	# NOTA: Opcionalmente, você pode chamar uma função aqui para atualizar 
	# a UI de HP/MP da party exibida na tela.

# ==========================================
# CANCEL ACTION
# ==========================================
func handle_back() -> bool:
	if current_state == States.PLAYER_SELECTION:
		cancel_player_selection()
		return true
	
	return false

func cancel_player_selection():
	current_state = States.SKILL_SELECTION
	if skill_to_use != null:
		var btn = get_button_for_skill(skill_to_use)
		if btn: 
			btn.grab_focus()
		skill_to_use = null

# ==========================================
# CONNECTED METHODS
# ==========================================
func _on_skill_changed(skill: Skill):
	skill_description.text = tr(skill.description)
