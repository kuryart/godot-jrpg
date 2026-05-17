extends SubViewportContainer

@onready var sub_viewport: SubViewport = $SubViewport
@onready var vfx_camera: Camera3D = %Camera3D

@export var vfx_bank_battle: VFXBank

static var container: SubViewportContainer = self

func _ready() -> void:
	container = self
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	call_deferred("move_to_front")

func play_at_screen_position(vfx: VFX, screen_position: Vector2, distance: float = 10.0):
	if not vfx or not vfx.vfx_node: return
	var instance = vfx.vfx_node.instantiate()

	if instance is Node3D:
		sub_viewport.add_child(instance)
		var pos_3d = vfx_camera.project_position(screen_position, distance)
		instance.global_position = pos_3d
	elif instance is Node2D or instance is Control:
		add_child(instance)
		instance.global_position = screen_position

	var max_lifetime := 0.0
	for child in instance.get_children():
		if child is GPUParticles3D:
			child.emitting = true
			max_lifetime = maxf(max_lifetime, child.lifetime)
	if max_lifetime > 0.0:
		get_tree().create_timer(max_lifetime + 0.1).timeout.connect(instance.queue_free)
