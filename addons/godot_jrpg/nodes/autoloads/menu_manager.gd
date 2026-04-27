extends Node

var stack: Array[Control] = []
var focus_history: Array[Control] = []
@export var menu_scene: PackedScene = preload("uid://bnxih5di4foi1")

func register_menu(menu: Control):
	var current_focus = get_viewport().gui_get_focus_owner()
	if current_focus:
		focus_history.push_back(current_focus)

	if not stack.is_empty():
		stack.back().process_mode = Node.PROCESS_MODE_DISABLED
	
	stack.push_back(menu)

func unregister_menu(menu: Control):
	stack.erase(menu)

	if not stack.is_empty():
		stack.back().process_mode = Node.PROCESS_MODE_INHERIT
	else:
		GameManager.change_game_state(GameManager.GameStates.MAP)

	if not focus_history.is_empty():
		var last_focus = focus_history.pop_back()

		if is_instance_valid(last_focus):
			last_focus.grab_focus.call_deferred()

func open_main_menu():
	if !GameManager.can_open_menu: return
	
	var menu_instance = menu_scene.instantiate()
	get_tree().root.add_child(menu_instance)
	await get_tree().process_frame 
	menu_instance.get_node("%Items").grab_focus()

func _input(event: InputEvent):
	if event.is_action_pressed("cancel"):
		if not stack.is_empty():
			var top = stack.back()
			if top.get_meta("menu_type") == "title": return
			top.queue_free()
			get_viewport().set_input_as_handled()
		else:
			open_main_menu()
			GameManager.change_game_state(GameManager.GameStates.MENU)
			get_viewport().set_input_as_handled()
