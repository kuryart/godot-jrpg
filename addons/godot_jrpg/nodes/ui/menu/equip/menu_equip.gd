extends Control

var player: Player

func _ready() -> void:
	MenuManager.register_menu(self)

func _exit_tree():
	MenuManager.unregister_menu(self)
