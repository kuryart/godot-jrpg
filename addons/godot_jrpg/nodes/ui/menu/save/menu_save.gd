# Menu Save
extends Control

@onready var options_list = %OptionsList

@export var new_file_button: PackedScene
@export var old_file_button: PackedScene

func _ready() -> void:
	MenuManager.register_menu(self)
	list_saves()

func _exit_tree():
	MenuManager.unregister_menu(self)

func list_saves() -> void:
	# 1. Clear panel
	for child in options_list.get_children():
		child.queue_free()
	
	# 2. Get files data
	var saves = SaveGame.get_all_saves()

	# 3. Instantiate buttons
	for i in range(saves.size()):
		var instance = old_file_button.instantiate()
		options_list.add_child(instance)
		var btn = instance if instance is Button else instance.find_child("*Button*", true, false)
		var date_str = format_save_date(saves[i]["time"])
		
		var btn_res = load(saves[i]["path"]) as SaveGame
		btn.text = "%s [%s]" % ["Save" + str(i + 1), date_str] + " - " + btn_res.current_scene_name
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		btn.pressed.connect(func(): _on_save_selected(saves[i]["path"]))
		
	var new_file_button = new_file_button.instantiate()
	new_file_button.get_child(0).button_up.connect(_on_new_file_button_pressed)
	options_list.add_child(new_file_button)
	
	# 4. Grab focus
	if options_list.get_child_count() > 0:
		var button = options_list.get_child(0).get_child(0)
		button.grab_focus()

func format_save_date(t: Dictionary) -> String:
	return "%02d/%02d/%04d %02d:%02d" % [t.day, t.month, t.year, t.hour, t.minute]

func create_label(text: String) -> void:
	var lbl = Label.new()
	lbl.text = text
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	options_list.add_child(lbl)

func _on_save_selected(path: String) -> void:
	GameManager.save_game(path)
	list_saves()
	options_list.get_child(-1).get_child(0).grab_focus()

func _on_new_file_button_pressed():
	GameManager.save_game("")
	list_saves()
	options_list.get_child(-1).get_child(0).grab_focus()
