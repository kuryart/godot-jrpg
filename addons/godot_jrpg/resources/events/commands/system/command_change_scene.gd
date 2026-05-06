class_name CommandChangeScene extends Command

@export var target_scene: PackedScene

static func create(scene: PackedScene) -> CommandChangeScene:
	var cmd = CommandChangeScene.new()
	cmd.target_scene = scene
	cmd.is_wait = true
	return cmd

#func resolve():
	#print("[CommandChangeScene] Changing to scene %s" % target_scene)
	#var director = Director.instance
	#var instance = target_scene.instantiate()
	#director.replace_scene(instance)
	#await Director.instance.get_tree().process_frame
	#print("[CommandChangeScene] Scene changed.")
	#
	#finished.emit()

func resolve():
	print("[CommandChangeScene] Changing to scene %s" % target_scene)
	
	if Director.instance != null:
		var instance = target_scene.instantiate()
		Director.instance.replace_scene(instance)
		await Director.instance.get_tree().process_frame
	else:
		var tree = Engine.get_main_loop() as SceneTree
		tree.change_scene_to_packed(target_scene)
		await tree.process_frame
		
	print("[CommandChangeScene] Scene changed.")
	finished.emit()
