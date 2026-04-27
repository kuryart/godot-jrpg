extends Control

func set_ui_lock(is_locked: bool) -> void:
	visible = is_locked
	
	if is_locked:
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()
