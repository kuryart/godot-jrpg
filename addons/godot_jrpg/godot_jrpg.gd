@tool
extends EditorPlugin

var database_ui: Control

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton("VFXManager", "res://addons/godot_jrpg/nodes/autoloads/vfx_manager.tscn")
	add_autoload_singleton("Audio", "res://addons/godot_jrpg/nodes/autoloads/audio.tscn")
	add_autoload_singleton("InputManager", "res://addons/godot_jrpg/nodes/autoloads/input_manager.tscn")
	
func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton("VFXManager")
	remove_autoload_singleton("Audio")
	remove_autoload_singleton("InputManager")

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	database_ui = preload("res://addons/godot_jrpg/editor/database/database_ui.tscn").instantiate()
	get_editor_interface().get_editor_main_screen().add_child(database_ui)
	_make_visible(false)
	add_custom_type("BattleEngine", "Node", preload("res://addons/godot_jrpg/nodes/battle/battle_engine.gd"), preload("res://icon.svg"))

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if database_ui:
		database_ui.queue_free()
		
func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if database_ui:
		database_ui.visible = visible

func _get_plugin_name() -> String:
	return "Database"

func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Object", "EditorIcons")
