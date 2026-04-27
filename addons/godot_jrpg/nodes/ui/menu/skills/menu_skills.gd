extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuManager.register_menu(self)

func _exit_tree():
	MenuManager.unregister_menu(self)
