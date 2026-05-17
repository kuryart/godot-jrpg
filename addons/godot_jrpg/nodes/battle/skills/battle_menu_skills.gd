class_name BattleMenuSkills extends PanelContainer

@onready var skills_grid: GridContainer = %SkillsGrid
@onready var messenger: RichTextLabel = %MessengerLabel

@export var battle_signals: BattleSignals
@export var skill_button: PackedScene

var current_player: Player = null

func _ready() -> void:
	battle_signals.skill_changed.connect(_on_skill_changed)
	battle_signals.player_changed.connect(_on_player_changed)

func _on_player_changed(player: Player) -> void:
	current_player = player

func get_player_skills() -> Array[Skill]:
	var result: Array[Skill] = []
	if current_player == null:
		return result

	if current_player.grimoire != null:
		for skill in current_player.grimoire.skills:
			if not result.has(skill):
				result.append(skill)

	if current_player.player_class != null and current_player.player_class.grimoire != null:
		for skill in current_player.player_class.grimoire.skills:
			if not result.has(skill):
				result.append(skill)

	return result

func rebuild_menu() -> void:
	for child in skills_grid.get_children():
		child.queue_free()

	var skills = get_player_skills()
	if skills.is_empty():
		return

	await get_tree().process_frame
	for skill in skills:
		var btn: BattleSkillButton = skill_button.instantiate()
		btn.skill = skill
		btn.text = tr(skill.display_name)
		skills_grid.add_child(btn)

	lock_focus_boundaries()

func lock_focus_boundaries() -> void:
	var cols = skills_grid.columns
	var total = skills_grid.get_child_count()
	for i in range(total):
		var btn: Button = skills_grid.get_child(i)
		btn.focus_neighbor_right = ""
		btn.focus_neighbor_left = ""
		btn.focus_neighbor_top = ""
		btn.focus_neighbor_bottom = ""

		var col = i % cols
		if col == cols - 1 or i == total - 1:
			btn.focus_neighbor_right = btn.get_path()
		if col == 0:
			btn.focus_neighbor_left = btn.get_path()
		if i < cols:
			btn.focus_neighbor_top = btn.get_path()
		if i + cols >= total:
			btn.focus_neighbor_bottom = btn.get_path()

func focus_first() -> void:
	if skills_grid.get_child_count() > 0:
		skills_grid.get_child(0).grab_focus()

func _on_skill_changed(skill: Skill) -> void:
	messenger.text = tr(skill.description)
