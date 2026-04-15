@tool
class_name DatabaseUI extends Control

@onready var new_enemy_button: Button = %NewEnemyButton
@onready var remove_enemy_button: Button = %RemoveEnemyButton

func _ready() -> void:
	new_enemy_button.icon = get_theme_icon("New", "EditorIcons")
	remove_enemy_button.icon = get_theme_icon("Remove", "EditorIcons")
