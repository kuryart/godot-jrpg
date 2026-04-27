## Class for managing booleans (switches).
## Helps manage encounters, spawns, special dialogue, etc.

## For example, a one-off dialogue option could toggle a switch,
## so that it is not able to be triggered again.
extends Object

## Save path to save/load switches
## Default location is inside AppData/Godot/YOUR_PROJECT_NAME/switches.SAVE
@export_file var SAVE_PATH := "user://switches.SAVE"

## List of a Name and Type (AKA. Switches).
@export var switches : Array[Switch]

## Saves switches to the file specified in SAVE_PATH
func save_switches() -> void:
	var file := FileAccess.open_compressed(SAVE_PATH, FileAccess.WRITE, FileAccess.COMPRESSION_DEFLATE)
	var json_dict := {}
	
	for switch : Switch in switches:
		json_dict[switch.name] = switch.state
	
	file.store_string(JSON.stringify(json_dict))
	file.close()

## Loads switches from the file specified in SAVE_PATH
func load_switches() -> void:
	if (FileAccess.file_exists(SAVE_PATH)):
		var file := FileAccess.open_compressed(SAVE_PATH, FileAccess.READ, FileAccess.COMPRESSION_DEFLATE)
		var file_content := file.get_as_text()
		var json_dict : Dictionary = JSON.parse_string(file_content)
		
		switches.clear()
		
		for element : String in json_dict:
			var switch := Switch.new()
			
			switch.name = element
			switch.state = json_dict[element]
			
			switches.append(switch)
		
		file.close()
	else: print("Unable to find switches file to load")

## Deletes all switches from the file specified in SAVE_PATH
func erase_switches() -> void:
	if (FileAccess.file_exists(SAVE_PATH)):
		var file := FileAccess.open_compressed(SAVE_PATH, FileAccess.WRITE, FileAccess.COMPRESSION_DEFLATE)
		
		switches.clear()
		file.store_string("")
		file.close()
	else: print("Unable to find switches file to erase")
 
## Adds a switch to the switches list
func create_switch(switch_name : String, switch_state := false) -> void:
	for switch : Switch in switches:
		if (switch.name == switch_name):
			print("Switch name already exists, assigning state instead.")
			set_switch_state(switch_name, switch_state)
			return
	
	var new_switch : Switch = Switch.new()
	
	new_switch.name = switch_name
	new_switch.state = switch_state
	
	switches.append(new_switch)

## Toggles a switch's state
func toggle_switch(switch_name : String) -> Variant:
	for switch : Switch in switches:
		if switch.name == switch_name:
			switch.state = !switch.state
			return switch.state
	
	printerr("Unable to toggle switch")
	return null

## Sets a switch's state to the one specified
func set_switch_state(switch_name : String, switch_state := false) -> void:
	for switch : Switch in switches:
		if switch.name == switch_name:
			switch.state = switch_state
			return
	
	printerr("Unable to set switch state")

## Returns the current state of the switch.
## If no switch is found, will return null by default.
func get_switch(switch_name : String) -> Variant:
	for switch : Switch in switches:
		if switch.name == switch_name:
			return switch.state
	
	printerr("Unable to find switch and return its state")
	return null

## Deletes a switch by name
func delete_switch(switch_name : String) -> void:
	for switch : Switch in switches:
		if switch.name == switch_name:
			switches.erase(switch)
			return
	
	printerr("Unable to find switch to remove")

## Returns all switches inside the `switches` list
func get_switches() -> Array: return switches
