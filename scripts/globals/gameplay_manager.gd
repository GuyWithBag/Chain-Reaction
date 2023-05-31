extends Node

signal game_started(players: Array[AtomPlayer])
signal game_ended(winner: AtomPlayer, losers: Array[AtomPlayer])

var winnable: bool = true
var first_atom_in_game_placed: bool = false

var win_screen: PackedScene = load("res://gui/win_screen/win_screen.tscn")
var winning_atom_player: AtomPlayer
var current_gameplay_game_start_data: GameStartData


func _ready() -> void: 
	AtomPlayersManager.only_one_team_remaining.connect(_on_only_one_team_remaining)


func _on_only_one_team_remaining(last_remaining_atom_player: AtomPlayer) -> void: 
	if winnable: 
		end_game(last_remaining_atom_player)


func end_game(winner: AtomPlayer) -> void: 
	winning_atom_player = winner
	UIManager.add_gui(win_screen.instantiate()) 
	game_ended.emit()
	
	
func undo_turn() -> void: 
	var turn_data: TurnData = UndoHistoryManager.pop_back_turn_data() 
	AtomSlotsManager.apply_undo_changes() 
	
	
