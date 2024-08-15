extends ScrollContainer
class_name PlayersDisplay

enum Mode {
	CURRENT_TOTAL_ATOMS, 
	TOTAL_ATOMS
}

var player_display: PackedScene = load("res://gui/players_display/widgets/player_display/player_display.tscn")
var style_box_duplicates: Dictionary = {}
#var world: GameWorld
#var managers: LocalManagers


@export var mode: Mode
@export var player_displays: Container


func _ready(): 
	#world = GameManager.world
	#managers = world.managers
	
	match mode: 
		Mode.CURRENT_TOTAL_ATOMS: 
			PlayersManager.finished_getting_players.connect(_on_finished_getting_players) 
			PlayersManager.player_has_been_eliminated.connect(_on_player_has_been_eliminated)
			PlayersManager.resetted.connect(
				func(): 
					for display in player_displays.get_children(): 
						display.queue_free() 
					style_box_duplicates.clear()
			)
		Mode.TOTAL_ATOMS: 
			initiate_total_atoms_player_displays()
	
	
func _on_finished_getting_players(players: Array[Player]) -> void: 
	initiate_player_displays(players)


func _on_player_has_been_eliminated(player: Player, _players_in_play: Array[Player]) -> void: 
	for display in player_displays.get_children(): 
		if display.player == player: 
			display.display.text = "Player %s : Eliminated! |" % player.team_number
			display.player_eliminated_animation(style_box_duplicates[player.team_number]) 
#			var tween: Tween = create_tween()
#			tween.tween_property(display, )


func _on_player_current_total_atoms_changed(_prev_count: int, new_count: int, display: PlayerDisplay) -> void: 
	display.format_text([str(display.player.team_number), str(new_count)])
	
	
func initiate_player_displays(players: Array[Player]) -> void: 
	for player in players: 
		var display: PlayerDisplay = player_display.instantiate()
		display.player = player
		player_displays.add_child(display)
		display.format_text([str(player.team_number), str(0)])
		style_box_duplicates[player.team_number] = display.change_panel_color(player.team_color)
		player.current_total_atoms_changed.connect(_on_player_current_total_atoms_changed.bind(display))
		if (player in PlayersManager.players_in_play) == false: 
			display.player_eliminated_animation(style_box_duplicates[player.team_number])


func initiate_total_atoms_player_displays() -> void: 
	for player in PlayersManager.players: 
		var display: PlayerDisplay = player_display.instantiate()
		display.player = player
		display.display_text = "Player %s total atoms: %s |"
		player_displays.add_child(display)
		display.format_text([str(player.team_number), str(player.total_atoms_added)])
		style_box_duplicates[player.team_number] = display.change_panel_color(player.team_color)

