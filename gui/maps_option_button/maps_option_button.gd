extends OptionButton
class_name MapsOptionButton


func _ready() -> void: 
	for map_data in MapsLoader.get_all_maps(): 
		add_item(map_data.map_name)

