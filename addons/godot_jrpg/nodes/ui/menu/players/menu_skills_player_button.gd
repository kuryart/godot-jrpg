class_name MenuSkillsPlayerButton extends Button

@onready var name_label: Label = get_parent().get_node("HBoxContainer/VBoxContainer2/Name")
@onready var level_label: Label = get_parent().get_node("HBoxContainer/VBoxContainer2/Level")
@onready var hp_label: Label = get_parent().get_node("HBoxContainer/Stats/HP/VBoxContainer/Current HP")
@onready var hp_bar: ProgressBar = get_parent().get_node("HBoxContainer/Stats/HP/VBoxContainer/HP Bar")
@onready var mp_label: Label = get_parent().get_node("HBoxContainer/Stats/MP/VBoxContainer/Current MP")
@onready var mp_bar: ProgressBar = get_parent().get_node("HBoxContainer/Stats/MP/VBoxContainer/MP Bar")

@export var menu_signals: MenuSignals

var player: Player

func _ready() -> void:
	button_up.connect(_on_button_up)
	name_label.text = player.name
	level_label.text = "Lv." + str(player.level)
	var max_hp = player.get_max_hp()
	hp_bar.max_value = max_hp
	hp_bar.value = player.current_hp
	hp_label.text = str(player.current_hp) + "/" + str(max_hp)
	var max_mp = player.get_max_mp()
	mp_bar.max_value = max_mp
	mp_bar.value = player.current_mp
	mp_label.text = str(player.current_mp) + "/" + str(max_mp)

func _on_button_up():
	menu_signals.menu_skills_player_selected.emit(player)
