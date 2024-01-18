extends PanelContainer

@onready var maps_option_button: MapsOptionButton = get_node("%MapsOptionButton") 
@onready var map_image: TextureRect = get_node("%MapImage")


func _ready() -> void: 
	set_map_image(maps_option_button.selected)


func _on_maps_option_button_item_selected(index: int) -> void:
	set_map_image(index)
	
	
func set_map_image(item_index: int) -> void: 
	var map_selected: String = maps_option_button.get_item_text(item_index) 
	var map_data: MapData = MapsLoader.get_map(map_selected) 
	map_image.texture = map_data.map_preview
