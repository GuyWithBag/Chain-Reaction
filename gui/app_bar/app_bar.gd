extends GUI
class_name AppBar

@onready var player_turn_label: Label = get_node("ColorRect/MarginContainer/HBoxContainer/PlayerTurn")

var player_turn_text: String = "Team %s Turn"


func _ready() -> void:
	AtomTeamTurnsManager.turn_started.connect(_on_turn_start)
	
	
func _on_turn_start() -> void: 
	player_turn_label.text = player_turn_text % str(AtomTeamTurnsManager.current_atom_team_in_turn.team_number)


