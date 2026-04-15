@tool
class_name DBEnemiesNewEnemyButton extends Button

func _ready() -> void:
	button_up.connect(_on_button_up)
	
func _on_button_up():
	print("[DBEnemies] new enemy created.")
