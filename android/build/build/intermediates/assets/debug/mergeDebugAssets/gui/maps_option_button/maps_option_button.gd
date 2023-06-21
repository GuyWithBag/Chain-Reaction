extends OptionButton
class_name MapsOptionButton

@onready var all_maps: Array[MapData] = MapsLoader.get_all_enabled_maps()


func _ready() -> void: 
	rearrange_listing() 
	for map_data in all_maps: 
		add_item(map_data.map_name)


func rearrange_listing() -> void: 
	var standard_world: MapData = MapsLoader.get_map("Standard World") 
	var standard_world_index: int = all_maps.find(standard_world) 
	var item: MapData = all_maps.pop_at(standard_world_index) 
	all_maps.insert(0, item) 
	
	
