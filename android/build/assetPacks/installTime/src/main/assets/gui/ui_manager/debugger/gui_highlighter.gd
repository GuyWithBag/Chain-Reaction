extends Control

@onready var gui_name_label: Label = get_node("GUIName")
@onready var gui_highlighter: ColorRect = get_node("GUIHighlight")


func highlight_gui(active: bool, gui_hovered: Control = null) -> void: 
	if get_parent().highlight_gui == false:
		return
	gui_highlighter.visible = active 
	if gui_hovered == null: 
		return
	gui_highlighter.size = gui_hovered.size
	gui_highlighter.global_position = gui_hovered.global_position
	label_gui(gui_hovered, active)
	
	
func label_gui(gui_hovered: Control, active: bool) -> void: 
	var gui_name: String = gui_hovered.name 
	gui_name_label.visible = active
	gui_name_label.text = gui_name
