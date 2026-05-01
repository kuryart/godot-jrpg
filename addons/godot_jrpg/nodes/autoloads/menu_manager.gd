extends Node

var stack: Array[Control] = []
var focus_history: Array[Control] = []
@export var menu_scene: PackedScene = preload("uid://bnxih5di4foi1")

func register_menu(menu: Control):
	# DEBUG: Agora você verá todo registro no console do Neovim/Godot
	print("[MenuManager] Trying to register menu: ", menu.name)
	
	var current_focus = get_viewport().gui_get_focus_owner()
	if current_focus:
		focus_history.push_back(current_focus)

	if not stack.is_empty():
		var previous_menu = stack.back()
		previous_menu.process_mode = Node.PROCESS_MODE_DISABLED
		previous_menu.hide()
		print("[MenuManager] Hiding last menu: ", previous_menu.name)
	
	stack.push_back(menu)
	print("[MenuManager] Stack: ", stack)

func unregister_menu(menu: Control):
	print("[MenuManager] Unregistering menu: ", menu.name)
	stack.erase(menu)

	if not stack.is_empty():
		var back_menu = stack.back()
		back_menu.process_mode = Node.PROCESS_MODE_INHERIT
		back_menu.show()
		print("[MenuManager] Restoring menu: ", back_menu.name)
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

func _input(event: InputEvent):
	if event.is_action_pressed("cancel"):
		if not stack.is_empty():
			var top = stack.back()

			if top.has_method("handle_back") and top.handle_back():
				return

			top.queue_free()
			get_viewport().set_input_as_handled()
		else:
			open_main_menu()
			GameManager.change_game_state(GameManager.GameStates.MENU)
			get_viewport().set_input_as_handled()
