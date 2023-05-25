extends OptionButton


func _ready() -> void: 
	for map_name in MapsLoader.all_maps.keys(): 
		add_item(map_name)


