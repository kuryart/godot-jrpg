class_name SaveState extends Resource

const SAVE_GAME_PATH:= "user://saves/save_game.tres"

@export var party: Party
@export var switches: Dictionary[String, Switch]
#@export var current_scene_name: String
#@export var current_scene_path: String
@export var current_time: String
@export var elapsed_time: String
@export var game_state: GameManager.GameStates
@export var last_game_state: GameManager.GameStates
@export var language: GameManager.Languages
@export var difficulty: GameManager.Difficulties

func write_save(path: String) -> void:
	var directory_path := path.get_base_dir()
	if not DirAccess.dir_exists_absolute(directory_path):
		DirAccess.make_dir_recursive_absolute(directory_path)
	
	print(path)
	ResourceSaver.save(self, path)

func load_save() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return SafeResourceLoader.load(SAVE_GAME_PATH)
	return null

func get_next_save_path() -> String:
	var dir_path := "user://saves/"
	var base_name := "save_game_"
	var extension := ".tres"
	
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)
	
	var dir := DirAccess.open(dir_path)
	var last_index := 0
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		var regex = RegEx.new()
		regex.compile(base_name + "(\\d+)" + extension)
		
		while file_name != "":
			var result = regex.search(file_name)
			if result:
				var current_index = result.get_string(1).to_int()
				if current_index > last_index:
					last_index = current_index
			file_name = dir.get_next()
		dir.list_dir_end()
	
	var new_index = last_index + 1
	var formatted_index = str(new_index).pad_zeros(3)
	
	return dir_path + base_name + formatted_index + extension

static func get_all_saves() -> Array[Dictionary]:
	var saves: Array[Dictionary] = []
	var path := "user://saves/"
	
	if not DirAccess.dir_exists_absolute(path):
		return saves

	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var full_path = path + file_name
				
				var unix_time = FileAccess.get_modified_time(full_path)
				var date_dict = Time.get_datetime_dict_from_unix_time(unix_time + (Time.get_time_zone_from_system().bias * 60))
				
				saves.append({
					"name": file_name,
					"path": full_path,
					"time": date_dict,
					"unix_time": unix_time
				})
			file_name = dir.get_next()
		dir.list_dir_end()
	
	saves.sort_custom(func(a, b): return a.unix_time > b.unix_time)
	
	return saves
