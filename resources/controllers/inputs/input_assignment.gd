class_name InputAssignment extends Resource

enum DeviceType { KEYBOARD, JOYPAD, AI }

@export var player_index: int = 0
@export var device_type: DeviceType = DeviceType.KEYBOARD
@export var device_id: int = 0
