class_name BattleMenuPlayers extends PanelContainer

@onready var players_v_box: VBoxContainer = %Players

@export var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

func _ready() -> void:
	battle_signals.go_to_players_menu_emitted.connect(_on_go_to_players_menu_emitted)

func go_to_player_selection():
	var child_count = players_v_box.get_child_count()
	
	for i in range(child_count):
		var current_btn = players_v_box.get_child(i)
		
		if i == 0:
			current_btn.focus_neighbor_top = current_btn.get_path()
			current_btn.focus_neighbor_right = current_btn.get_path()
			current_btn.focus_neighbor_left = current_btn.get_path()
			current_btn.focus_neighbor_bottom = "" 
		elif i == child_count - 1: 
			current_btn.focus_neighbor_top = ""
			current_btn.focus_neighbor_right = current_btn.get_path()
			current_btn.focus_neighbor_left = current_btn.get_path()
			current_btn.focus_neighbor_bottom = current_btn.get_path()
		else:
			current_btn.focus_neighbor_top = ""
			current_btn.focus_neighbor_right = current_btn.get_path()
			current_btn.focus_neighbor_left = current_btn.get_path()
			current_btn.focus_neighbor_bottom = "" 
	
	var first_player_button = players_v_box.get_child(0)
	first_player_button.grab_focus()

func _on_go_to_players_menu_emitted():
	go_to_player_selection()
