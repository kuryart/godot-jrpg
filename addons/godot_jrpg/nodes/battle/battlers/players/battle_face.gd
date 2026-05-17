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

func _ready() -> void:
	material = material.duplicate()
	material.set_shader_parameter("flash_percentage", 0.0)

func play_target_flash(battler_flash: BattlerFlash) -> void:
	if not battler_flash or not battler_flash.animation: return
	material.set_shader_parameter("flash_color", battler_flash.color)
	var lib_name := &""
	if not animation_player.has_animation_library(lib_name):
		animation_player.add_animation_library(lib_name, AnimationLibrary.new())
	var lib: AnimationLibrary = animation_player.get_animation_library(lib_name)
	var anim_name := &"_flash"
	if lib.has_animation(anim_name):
		lib.remove_animation(anim_name)
	lib.add_animation(anim_name, battler_flash.animation)
	animation_player.play(anim_name)

func get_attacked():
	#Audio.play_hit_sound()
	animation_player.stop()
	material.shader = shaders["damage"]
	material.set_shader_parameter("flash_color", Color.RED)
	animation_player.play("biblioteca/damage")
	await animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	battle_signals.damage_finished.emit()
