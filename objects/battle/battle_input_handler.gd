class_name BattleInputHandler extends Node

signal action_pressed
signal cancel_pressed

var assignment: InputAssignment

func _init(_assignment: InputAssignment) -> void:
	assignment = _assignment

func _unhandled_input(event: InputEvent) -> void:
	if event.device != assignment.device_id: return

	if assignment.device_type == InputAssignment.DeviceType.KEYBOARD:
		if event is InputEventJoypadButton or event is InputEventJoypadMotion: return
	elif assignment.device_type == InputAssignment.DeviceType.JOYPAD:
		if event is InputEventKey: return
	
	if event.is_action_pressed("action"):
		action_pressed.emit()

	if event.is_action_pressed("cancel"):
		cancel_pressed.emit()
