extends VBoxContainer
class_name BusVolumeSlider

var bus_idx: int

@onready var bus_name_label: Label = get_node("HBoxContainer/BusName") 
@onready var volume_label: Label = get_node("HBoxContainer/Volume") 
@onready var volume_slider: HSlider = get_node("VolumeSlider") 


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_idx, value) 
	volume_label.text = str(value)
