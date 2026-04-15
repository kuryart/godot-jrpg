class_name BattleFace extends TextureRect

@onready var animation_player = $AnimationPlayer

@export var icon_fight: CompressedTexture2D
@export var icon_run: CompressedTexture2D
@export var battle_signals: BattleSignals = preload("uid://creqo0s1k7tlr")

var player: Player

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
	await get_tree().create_timer(1.0).timeout
	battle_signals.damage_finished.emit()
