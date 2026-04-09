class_name TestMainMenu extends Control

signal finished

func _ready() -> void:
	print("[%s] Starting test." % name)
	print("[%s] Finished test." % name)
	finished.emit()
