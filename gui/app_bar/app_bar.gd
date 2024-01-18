extends GUI
class_name AppBar

@onready var atom_player_turns_manager = GameManager.world.managers.atom_player_turns_manager
@onready var player_turn_label: Label = get_node("PanelContainer/MarginContainer/HBoxContainer/PlayerTurn")

var player_turn_text: String = "Player %s Turn"


func _ready() -> void:
	atom_player_turns_manager.turn_started.connect(_on_turn_start)
	
	
func _on_turn_start() -> void: 
	var current_atom_player_in_turn: AtomPlayer = atom_player_turns_manager.current_atom_player_in_turn
	player_turn_label.text = player_turn_text % str(current_atom_player_in_turn.team_number)
	animate_font_color(current_atom_player_in_turn.team_color)


func animate_font_color(new_color: Color) -> void: 
#	var style_box: StyleBoxFlat = theme.get_stylebox("panel", "PlayerTurnLabel").duplicate() 
#	var tween: Tween = create_tween().set_parallel(true)
	var color_to_359: float = new_color.h * 359
	if (color_to_359 < 316 && color_to_359 > 223) || (color_to_359 < 240 && color_to_359 > 50): 
#		tween.tween_property(player_turn_label, "theme_override_colors/font_outline_color", Color.DIM_GRAY, 1) 
		player_turn_label.set("theme_override_colors/font_outline_color", Color.BLACK)
	else: 
#		tween.tween_property(player_turn_label, "theme_override_colors/font_outline_color", Color.DARK_GRAY, 1)
		player_turn_label.set("theme_override_colors/font_outline_color", Color.WHITE)
#	tween.tween_property(player_turn_label, "theme_override_colors/font_color", new_color, 0.4) 
	player_turn_label.set("theme_override_colors/font_color", new_color)
#	tween.play() 

