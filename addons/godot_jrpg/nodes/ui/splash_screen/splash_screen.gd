extends Node

@export var title_scene: PackedScene
@onready var logo = $TextureRect
@onready var label = $Label

func _ready() -> void:
	GameManager.change_game_state(GameManager.GameStates.INTRO)
	start_intro()

func start_intro():
	print("Intro started!")
	logo.modulate = Color.TRANSPARENT
	label.modulate = Color.TRANSPARENT
	await get_tree().create_timer(2.0).timeout
	var tween = get_tree().create_tween() # Tween interpolate things, used to create animations
	tween.tween_property(logo, "modulate", Color.WHITE, 1)
	await tween.tween_property(label, "modulate", Color.WHITE, 1).finished
	await get_tree().create_timer(4.0).timeout
	await Fade.fade_out(4.0).finished
	#get_tree().change_scene_to_packed(title_scene)
	EventRunner.run(CommandList.new().add_command(CommandChangeScene.create(title_scene)))
	GameManager.change_game_state(GameManager.GameStates.TITLE)
	
