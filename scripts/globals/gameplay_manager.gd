extends Node

signal game_started(players: Array[AtomTeam])
signal game_ended(winner: AtomTeam, losers: Array[AtomTeam])

var win_screen: PackedScene = load("res://gui/win_screen/win_screen.tscn")
var winning_atom_team: AtomTeam
var current_gameplay_game_start_data: GameStartData

func _ready() -> void: 
	AtomTeamsManager.only_one_team_remaining.connect(_on_only_one_team_remaining)


func _on_only_one_team_remaining(last_remaining_atom_team: AtomTeam) -> void: 
	end_game(last_remaining_atom_team)


func end_game(winner: AtomTeam) -> void: 
	winning_atom_team = winner
	UIManager.add_gui(win_screen.instantiate()) 
	game_ended.emit()
	

	
	
