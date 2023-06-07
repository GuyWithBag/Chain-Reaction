extends Node


var all_maps: Dictionary = {
	"standard_world" : MapData.new("Standard World", "res://scenes/game_world_levels/standard_world/standard_world.tscn"), 
	"standard_world_extended" : MapData.new("Standard World Extended", "res://scenes/game_world_levels/standard_world/standard_world_extended.tscn"), 
	"medium_world" : MapData.new("Medium World", "res://scenes/game_world_levels/medium_world/medium_world.tscn"), 
}


func get_map(map_name: String) -> MapData: 
	var map_id: String = map_name.to_snake_case() 
	return all_maps[map_id]
	
	
func get_all_maps() -> Array[MapData]: 
	var maps: Array[MapData] = []
	for map_data in MapsLoader.all_maps.values(): 
		if map_data.map_url.ends_with("extended.tscn"): 
			continue 
		maps.append(map_data)
	return maps
	
	
