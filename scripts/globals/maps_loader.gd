extends Node


var all_maps: Dictionary = {
	"game_world_1" : MapData.new("Game World 1", "res://scenes/game_world_levels/game_world_1/game_world_1.tscn")
}


func get_map(map_name: String) -> MapData: 
	var map_id: String = map_name.to_snake_case() 
	return all_maps[map_id]
	
	
