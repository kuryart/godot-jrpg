class_name CommandChangeScene extends Command

@export var target_scene: PackedScene

static func create(scene: PackedScene) -> CommandChangeScene:
	var cmd = CommandChangeScene.new()
	cmd.target_scene = scene
	cmd.is_wait = true
	return cmd

func resolve():
	print("[CommandChangeScene] Changing to scene %s" % target_scene)
	var director = Director.instance
	var instance = target_scene.instantiate()
	director.replace_scene(instance)
	await Director.instance.get_tree().process_frame
	print("[CommandChangeScene] Scene changed.")
	
	finished.emit()
