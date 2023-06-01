extends PanelContainer

var audio_busses: PackedStringArray
var bus_volume_slider: PackedScene = load("res://gui/options_menu/widget/bus_volume_slider/bus_volume_slider.tscn") 

@onready var list: VBoxContainer = get_node("Panel/VBoxContainer/ReferenceRect/VBoxContainer") 

func _ready() -> void: 
	for count in AudioServer.bus_count: 
		var slider: BusVolumeSlider = bus_volume_slider.instantiate()
		list.add_child(slider)
		slider.bus_name_label.text = AudioServer.get_bus_name(count)
		


