extends ScrollContainer

var player_display: PackedScene = load("res://gui/players_display/widgets/player_display/player_display.tscn")

@onready var player_displays: GridContainer = get_node("GridContainer")

func _ready(): 
	AtomPlayersManager.finished_getting_atom_players.connect(_on_finished_getting_atom_players)
	
	
func _on_finished_getting_atom_players(atom_players: Array[AtomPlayer]) -> void: 
	for atom_player in atom_players: 
		var display: PlayerDisplay = player_display.instantiate()
		display.atom_player = atom_player
		player_displays.add_child(display)
		display.format_text([str(atom_player.team_number), str(0)])
		atom_player.total_atoms_changed.connect(_on_atom_player_total_atoms_changed.bind(display))


func _on_atom_player_total_atoms_changed(prev_count: int, new_count: int, display: PlayerDisplay) -> void: 
	display.format_text([str(display.atom_player.team_number), str(new_count)])
	
	

