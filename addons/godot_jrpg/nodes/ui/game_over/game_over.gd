class_name GameOver extends Control

@export var title_scene = preload("uid://daeh6hcpb60r1")

var can_change_scene: bool = false
var is_fading: bool = false

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	can_change_scene = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action") and can_change_scene and not is_fading:
		is_fading = true
		await Fade.fade_out(4.0).finished
		var flow = CommandList.new()
		flow.add_command(CommandChangeScene.create(title_scene))
		EventRunner.run(flow)
