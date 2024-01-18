extends OptionListTile


var audio_busses: PackedStringArray
var bus_volume_slider: PackedScene = load("res://gui/options_menu/widget/bus_volume_slider/bus_volume_slider.tscn") 


func _ready() -> void: 
	for count in AudioServer.bus_count: 
		var slider: BusVolumeSlider = bus_volume_slider.instantiate()
		list.add_child(slider)
		var bus_name: String = AudioServer.get_bus_name(count)
		slider.bus_name_label.text = bus_name
		slider.bus_idx = AudioServer.get_bus_index(bus_name)



