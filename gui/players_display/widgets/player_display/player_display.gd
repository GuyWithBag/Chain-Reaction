extends Control
class_name PlayerDisplay

var atom_player: AtomPlayer 
var display_text: String = "Player %s atoms left: %s |"

@onready var panel: PanelContainer =  get_node("Panel")
@onready var display: Label = panel.get_node("MarginContainer/Display") 


func format_text(format: Array[String]) -> void: 
	display.text = display_text % format


func change_panel_color(new_color: Color) -> StyleBoxFlat: 
	var style_box: StyleBoxFlat = theme.get_stylebox("panel", "ScoreboardPanelContainer").duplicate() 
	style_box.bg_color = new_color
	panel.add_theme_stylebox_override("panel", style_box) 
	return style_box
	
	
func player_eliminated_animation(style_box: StyleBoxFlat) -> void: 
#	if !is_instance_valid(style_box): 
#		return
#	var tween: Tween = create_tween().bind_node(self)
#	var to_border_width: int = 10
#	var to_duration: float = 0.1 
#	var to_back_duration: float = 0.1
#	tween.tween_property(style_box, "border_width_up", to_border_width, to_duration)
#	tween.tween_property(style_box, "border_width_left", to_border_width, to_duration)
#	tween.tween_property(style_box, "border_width_right", to_border_width, to_duration)
#	tween.tween_property(style_box, "border_width_top", to_border_width, to_duration)
#
#	tween.tween_property(style_box, "border_width_up", 0, to_back_duration)
#	tween.tween_property(style_box, "border_width_left", 0, to_back_duration)
#	tween.tween_property(style_box, "border_width_right", 0, to_back_duration)
#	tween.tween_property(style_box, "border_width_top", 0, to_back_duration) 
#	tween.play()
	pass
	
	
	
