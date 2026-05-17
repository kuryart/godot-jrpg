extends Node

@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var vfx_camera: Camera3D = %Camera3D
@onready var screen_flash_rect: ColorRect = %ScreenFlashRect
@onready var screen_flash_player: AnimationPlayer = %ScreenFlashPlayer

@export var vfx_bank_battle: VFXBank

func _ready() -> void:
	call_deferred("_move_to_front")

func _move_to_front() -> void:
	var parent := get_parent()
	if parent:
		parent.move_child(self, parent.get_child_count() - 1)

func play_at_screen_position(vfx: VFX, screen_position: Vector2, distance: float = 10.0):
	if not vfx or not vfx.vfx_node: return
	var instance = vfx.vfx_node.instantiate()

	if instance is Node3D:
		sub_viewport.add_child(instance)
		var pos_3d = vfx_camera.project_position(screen_position, distance)
		instance.global_position = pos_3d
	elif instance is Node2D or instance is Control:
		sub_viewport_container.add_child(instance)
		instance.global_position = screen_position

	var max_lifetime := 0.0
	for child in instance.get_children():
		if child is GPUParticles3D:
			child.emitting = true
			max_lifetime = maxf(max_lifetime, child.lifetime)
	if max_lifetime > 0.0:
		get_tree().create_timer(max_lifetime + 0.1).timeout.connect(instance.queue_free)

func play_screen_flash(flash: FlashEffect) -> void:
	if not flash or not flash.animation: return
	screen_flash_rect.color = flash.color
	var lib_name := &""
	if not screen_flash_player.has_animation_library(lib_name):
		screen_flash_player.add_animation_library(lib_name, AnimationLibrary.new())
	var lib := screen_flash_player.get_animation_library(lib_name)
	var anim_name := &"_flash"
	if lib.has_animation(anim_name):
		lib.remove_animation(anim_name)
	lib.add_animation(anim_name, flash.animation)
	screen_flash_player.play(anim_name)
