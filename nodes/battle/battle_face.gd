class_name BattleFace extends TextureRect

@onready var animation_player = $AnimationPlayer

@export var icon_fight: CompressedTexture2D
@export var icon_run: CompressedTexture2D

var shaders = {
	"flash": preload("uid://c5ntiylsybtxo"),
	"damage": preload("uid://clyi8d64f0spx"),
}

func get_attacked():
	#Audio.play_hit_sound()
	animation_player.stop()
	material.shader = shaders["damage"]
	material.set_shader_parameter("flash_color", Color.RED)
	animation_player.play("biblioteca/damage")
	await animation_player.animation_finished
