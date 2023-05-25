extends Node

signal only_one_team_remaining(last_remaining_atom_team: AtomTeam)

signal team_has_been_eliminated(eliminated_atom_team: AtomTeam, alive_teams: Array[AtomTeam])

signal only_two_teams_left(atom_team_1: AtomTeam, atom_team_2: AtomTeam)

var player_amount: int = 0

var atom_teams: Array[AtomTeam] = [] 

var atom_teams_in_play: Array[AtomTeam] = []

var atom_team_colors: Dictionary = {
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
#	for atom_team in atom_teams_in_play: 
#		var atom_count: int = AtomTeamsManager.get_total_atoms_count(atom_team)
#		print("Atom Team: %s, Atom Count: %s" % [atom_team.team_number, atom_count])
#		if atom_count <= 0: 
#			AtomTeamsManager.elimnate_team(atom_team)
#			print("Elimnated")
		

func reset() -> void: 
	atom_teams.clear()
	atom_teams_in_play.clear()
	
# Called by GameManager.start_game() 
func start_game(_player_amount: int) -> void: 
	player_amount = _player_amount
	for team_number in player_amount: 
		var atom_team: AtomTeam = AtomTeam.new(team_number, atom_team_colors[team_number])
		atom_teams.append(atom_team)
		atom_teams_in_play.append(atom_team)
	AtomTeamTurnsManager.start_game()


func get_total_atoms_count(atom_team: AtomTeam) -> int: 
	var total_atoms: int = 0
	var atom_slots: Array = get_tree().get_nodes_in_group(str(atom_team.team_number))
	for atom_slot in atom_slots: 
		total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
	return total_atoms
	
	
func get_total_atoms_count_by_team_number(atom_team_number: int) -> int: 
	var total_atoms: int = 0
	var atom_slots: Array = get_tree().get_nodes_in_group(str(atom_team_number))
	for atom_slot in atom_slots: 
		total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
	return total_atoms
	
	
func elimnate_team(atom_team: AtomTeam) -> void: 
	# TODO: Wont erase third team for some reason
#	printerr("AS: ", atom_teams_in_play.size())
#		printerr(atom_team_in_play.team_number)
	atom_teams_in_play.erase(atom_team)
	team_has_been_eliminated.emit(atom_team, atom_teams_in_play)
	var atom_teams_remaining: int = atom_teams_in_play.size()
	print("AtomTeamsManager: Current teams remaining: %s" % atom_teams_remaining)
	if atom_teams_remaining == 2: 
		only_two_teams_left.emit(atom_teams_in_play[0], atom_teams_in_play[1])
	elif atom_teams_remaining == 1: 
		only_one_team_remaining.emit(atom_teams_in_play[0])

