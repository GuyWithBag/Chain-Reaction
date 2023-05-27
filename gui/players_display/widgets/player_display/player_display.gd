extends Control
class_name PlayerDisplay

var atom_player: AtomPlayer 
var display_text: String = "Player %s atoms left: %s |"

@onready var panel: PanelContainer =  get_node("Panel")
@onready var display: Label = panel.get_node("MarginContainer/Display") 


func format_text(format: Array[String]) -> void: 
	display.text = display_text % format


func change_panel_color(new_color: Color) -> void: 
	var style_box: StyleBoxFlat = theme.get_stylebox("panel", "ScoreboardPanelContainer").duplicate() 
	style_box.bg_color = new_color
	panel.add_theme_stylebox_override("panel", style_box) 
	
	
