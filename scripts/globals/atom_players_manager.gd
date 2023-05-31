extends Node

signal resetted
signal finished_getting_atom_players(atom_players: Array[AtomPlayer])

signal only_one_team_remaining(last_remaining_atom_player: AtomPlayer)
signal player_has_been_eliminated(eliminated_atom_player: AtomPlayer, alive_teams: Array[AtomPlayer])
signal only_two_teams_left(atom_player_1: AtomPlayer, atom_player_2: AtomPlayer)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var player_amount: int = 0

var atom_players: Array[AtomPlayer] = [] 

var previous_atoms_in_play: Array[AtomPlayer] = []
var atom_players_in_play: Array[AtomPlayer] = []

var atom_player_colors: Dictionary = {
	1 : Color(1, 0, 0), 
	2 : Color(1, 1, 0), 
	3 : Color(0, 0, 1), 
	4 : Color(0, 1, 0), 
	5 : Color(0, 1, 1), 
} 


func _ready() -> void: 
#	ChainReactionSequenceManager.chain_reaction_sequence_finished.connect(_on_chain_reaction_sequence_finished)
#	AtomSlotsManager.atom_slot_exploded.connect(_on_atom_slot_exploded)
	pass


func _on_atom_player_total_atoms_changed(prev_amount: int, new_amount: int, atom_player: AtomPlayer) -> void: 
	if atom_player.first_atom_has_been_placed == false: 
		return
	detect_which_team_is_eliminated(atom_player)
	
	
func detect_which_team_is_eliminated(atom_player: AtomPlayer) -> void: 
	await get_tree().create_timer(1, false).timeout
	var atom_count: int = get_total_atoms_count(atom_player)
	print("AtomPlayersManager: %s: Atom Count: %s" % [atom_player.group_name, atom_count])
	if atom_count <= 0: 
		if AtomPlayerTurnsManager.is_chain_reacting(): 
			await AtomSlotsManager.atom_slot_exploded
		if atom_players_in_play.find(atom_player) == 0: 
			return
		AtomPlayersManager.elimnate_team(atom_player)


func reset() -> void: 
	atom_players.clear()
	atom_players_in_play.clear()
	resetted.emit()
	
	
# Called by GameManager.start_game() 
func start_game(_player_amount: int) -> void: 
	player_amount = _player_amount
	for amount in player_amount: 
		var team_number: int = amount + 1 
		var team_color: Color
		if team_number > atom_player_colors.size(): 
			team_color = get_random_color() 
		else: 
			team_color = atom_player_colors[team_number]
		var atom_player: AtomPlayer = AtomPlayer.new(team_number, team_color)
		atom_players.append(atom_player)
		atom_players_in_play.append(atom_player)
	finished_getting_atom_players.emit(atom_players_in_play)
	for player in atom_players: 
		player.total_atoms_changed.connect(_on_atom_player_total_atoms_changed.bind(player))
	AtomPlayerTurnsManager.start_game()


func get_total_atoms_count(atom_player: AtomPlayer) -> int: 
	var total_atoms: int = 0
	var atom_slots: Array = get_tree().get_nodes_in_group(atom_player.group_name)
	for atom_slot in atom_slots: 
		total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
	return total_atoms
	
	
#func get_total_atoms_count_by_team_number(atom_player_number: int) -> int: 
#	var total_atoms: int = 0
#	var atom_slots: Array = get_tree().get_nodes_in_group(str(atom_player_number))
#	for atom_slot in atom_slots: 
#		total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
#	return total_atoms
	
	
func get_random_color() -> Color: 
	rng.randomize() 
	var r: float = rng.randf_range(0.1, 1)
	rng.randomize() 
	var g: float = rng.randf_range(0.3, 1)
	rng.randomize() 
	var b: float = rng.randf_range(0.1, 1)
	return Color(r, g, b)
	
	
func elimnate_team(atom_player: AtomPlayer) -> void: 
	# TODO: Wont erase third team for some reason
#	printerr("AS: ", atom_players_in_play.size())
#		printerr(atom_player_in_play.team_number)
	atom_players_in_play.erase(atom_player)
	player_has_been_eliminated.emit(atom_player, atom_players_in_play)
	var atom_players_remaining: int = atom_players_in_play.size()
	print("AtomPlayersManager: %s has been eliminated!" % atom_player.group_name)
	print("AtomPlayersManager: Current teams remaining: %s" % atom_players_remaining)
	if atom_players_remaining == 2: 
		only_two_teams_left.emit(atom_players_in_play[0], atom_players_in_play[1])
	elif atom_players_remaining == 1: 
		only_one_team_remaining.emit(atom_players_in_play[0])


# Called from UndoHistorymanager
func apply_undo_changes(turn_data: TurnData) -> void: 
	atom_players_in_play = turn_data.atom_players_in_play
