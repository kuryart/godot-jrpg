extends SubViewportContainer

@onready var vfx_camera: Camera3D = get_node("%Camera3D")

@export var vfx_bank_battle: VFXBank

var container: SubViewportContainer = self

func play_at_screen_position(vfx_name: String, vfx_bank: VFXBank, screen_position: Vector2, distance: float):
	var vfx: VFX = vfx_bank.bank[vfx_name]
	var pos_3d = vfx_camera.project_position(screen_position, distance)
	vfx.vfx_node.global_position = pos_3d
