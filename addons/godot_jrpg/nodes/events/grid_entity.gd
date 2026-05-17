@tool
class_name GridEntity extends Node2D

const TILE_SIZE := Vector2(32, 32)

var _current_coord: Vector2i

@export var grid_coord: Vector2i:
	get:
		return _current_coord

@export_tool_button("Calculate Grid Coordinates") var _snap_button = _apply_snap

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		_current_coord = _calculate_grid_coord()

func _apply_snap() -> void:
	_current_coord = _calculate_grid_coord()
	notify_property_list_changed()

func _calculate_grid_coord() -> Vector2i:
	return Vector2i(
		int(global_position.x / TILE_SIZE.x),
		int(global_position.y / TILE_SIZE.y)
	)
