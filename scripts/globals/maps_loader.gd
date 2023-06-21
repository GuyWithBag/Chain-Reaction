extends Node

var path: String = "res://scenes/game_world_levels/" 

# Map ID (map_name snake_case) : MapData 

var all_maps: Dictionary = {} 

func _init() -> void: 
	_load_maps()
	
	
func _load_maps() -> void: 
	var levels: PackedStringArray = DirAccess.get_directories_at(path)
	for level in levels: 
		var level_path: String = path + level + "/"
		var files: PackedStringArray = DirAccess.get_files_at(level_path) 
		for file in files: 
			var file_path: String = level_path + file
			if file == "map_data.tres.remap": 
				file = file.trim_suffix(".remap")
			if file == "map_data.tres": 
				var map_data: MapData = load(file_path)
				all_maps[map_data.map_name.to_snake_case()] = map_data 
	
	
func get_map(map_name: String) -> MapData: 
	var map_id: String = map_name.to_snake_case() 
	return all_maps[map_id]
	
	
func get_all_maps() -> Array[MapData]: 
	var maps: Array[MapData] = []
	for map_data in MapsLoader.all_maps.values(): 
		maps.append(map_data)
	return maps
	
	
func get_all_enabled_maps() -> Array[MapData]: 
	var maps: Array[MapData] = []
	for map_data in MapsLoader.all_maps.values(): 
		if map_data.disabled: 
			continue
		maps.append(map_data)
	return maps
