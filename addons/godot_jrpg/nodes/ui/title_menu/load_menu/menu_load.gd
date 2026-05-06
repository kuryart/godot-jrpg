class_name MenuLoad extends Control

@onready var options_list = %OptionsList

@export var old_file_button: PackedScene = preload("uid://crap7j7473tk8")

func _ready() -> void:
	MenuManager.register_menu(self)
	list_saves()

func _exit_tree():
	MenuManager.unregister_menu(self)

func list_saves() -> void:
	for child in options_list.get_children():
		child.queue_free()

	var saves = SaveState.get_all_saves()

	if saves.is_empty():
		create_label("Nenhum jogo salvo encontrado.")
		return

	for i in range(saves.size()):
		var instance = old_file_button.instantiate()
		options_list.add_child(instance)

		var btn = instance if instance is Button else instance.find_child("*Button*", true, false)
		var date_str = format_save_date(saves[i]["time"])

		var btn_res = SafeResourceLoader.load(saves[i]["path"]) as SaveState
		
		btn.text = "Load %s [%s] - %s" % [str(i + 1), date_str, "btn_res.current_scene_name"]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(func(): _on_load_selected(saves[i]["path"]))

	if options_list.get_child_count() > 0:
		var first_child = options_list.get_child(0)
		if first_child is MarginContainer: 
			first_child.get_child(0).grab_focus()
		elif first_child is Button:
			first_child.grab_focus()

func format_save_date(t: Dictionary) -> String:
	return "%02d/%02d/%04d %02d:%02d" % [t.day, t.month, t.year, t.hour, t.minute]

func create_label(text: String) -> void:
	var lbl = Label.new()
	lbl.text = text
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	options_list.add_child(lbl)

func _on_load_selected(path: String) -> void:
	GameManager.load_game(path)
