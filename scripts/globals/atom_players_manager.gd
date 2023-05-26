extends Node

signal resetted
signal finished_getting_atom_players(atom_players: Array[AtomPlayer])

signal only_one_team_remaining(last_remaining_atom_player: AtomPlayer)
signal player_has_been_eliminated(eliminated_atom_player: AtomPlayer, alive_teams: Array[AtomPlayer])
signal only_two_teams_left(atom_player_1: AtomPlayer, atom_player_2: AtomPlayer)

var player_amount: int = 0

var atom_players: Array[AtomPlayer] = [] 

var atom_players_in_play: Array[AtomPlayer] = []

var atom_player_colors: Dictionary = {
	0 : Color(1, 0, 0), 
	1 : Color(0, 1, 0), 
	2 : Color(0, 0, 1), 
	3 : Color(1, 1, 0), 
	4 : Color(0, 1, 1), 
	5 : Color(1, 0, 1), 
	6 : Color(1, 0.5, 0), 
	7 : Color(1, 0.5, 0.5), 
	8 : Color(0.5, 1, 0.5), 
}


#func _ready() -> void: 
#	ChainReactionSequenceManager.chain_reaction_sequence_finished.connect(_on_chain_reaction_sequence_finished)
#
#
#func _on_chain_reaction_sequence_finished() -> void: 
#	for atom_player in atom_players_in_play: 
#		var atom_count: int = AtomPlayersManager.get_total_atoms_count(atom_player)
#		print("Atom Team: %s, Atom Count: %s" % [atom_player.team_number, atom_count])
#		if atom_count <= 0: 
#			AtomPlayersManager.elimnate_team(atom_player)
#			print("Elimnated")


func reset() -> void: 
	atom_players.clear()
	atom_players_in_play.clear()
	resetted.emit()
	
# Called by GameManager.start_game() 
func start_game(_player_amount: int) -> void: 
	player_amount = _player_amount
	for team_number in player_amount: 
		var atom_player: AtomPlayer = AtomPlayer.new(team_number, atom_player_colors[team_number])
		atom_players.append(atom_player)
		atom_players_in_play.append(atom_player)
	finished_getting_atom_players.emit(atom_players_in_play)
	AtomPlayerTurnsManager.start_game()


func get_total_atoms_count(atom_player: AtomPlayer) -> int: 
#	var total_atoms: int = 0
#	var atom_slots: Array = get_tree().get_nodes_in_group(str(atom_player.team_number))
#	for atom_slot in atom_slots: 
#		total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
#	return total_atoms
	return atom_player.total_atoms
	
	
#func get_total_atoms_count_by_team_number(atom_player_number: int) -> int: 
#	var total_atoms: int = 0
#	var atom_slots: Array = get_tree().get_nodes_in_group(str(atom_player_number))
#	for atom_slot in atom_slots: 
#		total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
#	return total_atoms
	
	
func elimnate_team(atom_player: AtomPlayer) -> void: 
	# TODO: Wont erase third team for some reason
#	printerr("AS: ", atom_players_in_play.size())
#		printerr(atom_player_in_play.team_number)
	atom_players_in_play.erase(atom_player)
	player_has_been_eliminated.emit(atom_player, atom_players_in_play)
	var atom_players_remaining: int = atom_players_in_play.size()
	print("AtomPlayersManager: Current teams remaining: %s" % atom_players_remaining)
	if atom_players_remaining == 2: 
		only_two_teams_left.emit(atom_players_in_play[0], atom_players_in_play[1])
	elif atom_players_remaining == 1: 
		only_one_team_remaining.emit(atom_players_in_play[0])

