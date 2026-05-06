class_name EventArea extends Node

@onready var event_bus: = $EventBus

signal fired

func _ready() -> void:
	add_to_group("event")
	fired.connect(event_bus._on_event_fired)

func fire_event():
	fired.emit()
