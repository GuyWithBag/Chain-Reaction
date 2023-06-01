extends VBoxContainer
class_name BusVolumeSlider

@onready var bus_name_label: Label = get_node("HBoxContainer/BusName") 
@onready var volume_label: Label = get_node("HBoxContainer/Volume") 
@onready var bolume_slider: HSlider = get_node("VolumeSlider") 
