extends GridContainer

signal save_slot_selected(save_slot: SaveSlotButton) 

var current_selected: SaveSlotButton
var previous_selected: SaveSlotButton

var parent_gui: Control
var save_slot_button: PackedScene = load("res://ui/pause_menu/pages/save_slots/save_slot/save_slot_button.tscn")

@onready var save_slots: Array[SaveSlotButton]: 
	get:
		return get_save_slots()       

# There is something wrong with "FileAccess.parse_string()" (data won't parse or write even tho the string is correct. It might be because of Godot 4.0.1. This will be disablewd for now
# Turns out it's because i closed the file, but still confusing since i closed it after. 

func load_save_slots() -> void: 
	clear_save_slots()
	for save_file in SaveManager.get_save_files(): 
		add_save_slot(save_file)


func _on_save_slot_pressed(save_slot: SaveSlotButton) -> void: 
	print_debug(save_slot.button_pressed)
	if save_slot.button_pressed == true: 
		current_selected = save_slot
		previous_selected = null
		save_slot_selected.emit(save_slot)
	else: 
		current_selected = null


func get_save_slots() -> Array[SaveSlotButton]: 
	var _save_slots: Array[SaveSlotButton] = []
	for control in get_children(): 
		_save_slots.append(control) 
	return _save_slots


func add_save_slot(save_file: SaveFile) -> void: 
	var button: SaveSlotButton = save_slot_button.instantiate() 
	add_child(button) 
	button.pressed.connect(_on_save_slot_pressed.bind(button))
	button.save_file = save_file
	
	
func clear_save_slots() -> void: 
	for slot in save_slots: 
		slot.queue_free()
	save_slots.clear()
