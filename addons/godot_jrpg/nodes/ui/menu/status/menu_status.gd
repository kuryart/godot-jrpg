extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test")
	MenuManager.register_menu(self)
	focus_mode = Control.FOCUS_ALL
	grab_focus()

func _exit_tree():
	MenuManager.unregister_menu(self)
