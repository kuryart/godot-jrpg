class_name CommandCameraShake extends Command

@export var intensity: float = 5.0
@export var duration: float = 0.5

func resolve():
	var camera = Engine.get_main_loop().root.get_viewport().get_camera_2d()
	camera.shake(intensity, duration)
	finished.emit()
