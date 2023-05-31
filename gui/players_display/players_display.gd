extends ScrollContainer

var player_display: PackedScene = load("res://gui/players_display/widgets/player_display/player_display.tscn")
var style_box_duplicates: Dictionary = {}

@onready var player_displays: GridContainer = get_node("GridContainer")

func _ready(): 
	AtomPlayersManager.finished_getting_atom_players.connect(_on_finished_getting_atom_players) 
	AtomPlayersManager.player_has_been_eliminated.connect(_on_player_has_been_eliminated)
	AtomPlayersManager.resetted.connect(
		func(): 
			for display in player_displays.get_children(): 
				display.queue_free() 
			style_box_duplicates.clear()
	)
	
	
func _on_finished_getting_atom_players(atom_players: Array[AtomPlayer]) -> void: 
	for atom_player in atom_players: 
		var display: PlayerDisplay = player_display.instantiate()
		display.atom_player = atom_player
		player_displays.add_child(display)
		display.format_text([str(atom_player.team_number), str(0)])
		style_box_duplicates[atom_player.team_number] = display.change_panel_color(atom_player.team_color)
		atom_player.total_atoms_changed.connect(_on_atom_player_total_atoms_changed.bind(display))


func _on_player_has_been_eliminated(atom_player: AtomPlayer, atom_players_in_play: Array[AtomPlayer]) -> void: 
	for display in player_displays.get_children(): 
		if display.atom_player == atom_player: 
			display.display.text = "Player %s : Eliminated! |" % atom_player.team_number
			display.player_eliminated_animation(style_box_duplicates[atom_player.team_number]) 
#			var tween: Tween = create_tween()
#			tween.tween_property(display, )


func _on_atom_player_total_atoms_changed(prev_count: int, new_count: int, display: PlayerDisplay) -> void: 
	display.format_text([str(display.atom_player.team_number), str(new_count)])
	
	

