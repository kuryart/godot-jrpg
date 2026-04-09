extends Node

signal input_setup_complete

var assignments: Array[InputAssignment] = []

func _ready() -> void:
	configure()

func configure() -> void:
	assignments.clear()
	
	if DisplayServer.get_name() == "headless":
		setup_headless()
	else:
		setup_hardware()
		
	print("[InputManager] Setup finished.")
	input_setup_complete.emit()

func setup_hardware() -> void:
	assignments.append(create_assignment(0, InputAssignment.DeviceType.KEYBOARD, 0))
	print_assignment(assignments[0])

	var joys = Input.get_connected_joypads()
	for i in range(joys.size()):
		var player_id = i + 1
		if player_id > 3: break
		assignments.append(create_assignment(player_id, InputAssignment.DeviceType.JOYPAD, joys[i]))
		print_assignment(assignments[player_id])

func print_assignment(a: InputAssignment) -> void:
	print("[InputManager] Player %d | Device %d | Type %d | CONNECTED" % [a.player_index, a.device_id, a.device_type])

func setup_headless() -> void:
	for i in range(4):
		assignments.append(create_assignment(i, InputAssignment.DeviceType.AI, -1))

func create_assignment(player_id: int, device_type: int, device_id: int) -> InputAssignment:
	var input = InputAssignment.new()
	input.player_index = player_id
	input.device_type = device_type
	input.device_id = device_id
	return input

func get_assignment(player_id: int) -> InputAssignment:
	for a in assignments:
		if a.player_index == player_id:
			return a
	return null
