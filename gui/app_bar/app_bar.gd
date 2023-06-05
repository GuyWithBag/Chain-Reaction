extends GUI
class_name AppBar

@onready var player_turn_label: Label = get_node("PanelContainer/MarginContainer/HBoxContainer/PlayerTurn")

var player_turn_text: String = "Player %s Turn"


func _ready() -> void:
	AtomPlayerTurnsManager.turn_started.connect(_on_turn_start)
	
	
func _on_turn_start() -> void: 
	player_turn_label.text = player_turn_text % str(AtomPlayerTurnsManager.current_atom_player_in_turn.team_number)


