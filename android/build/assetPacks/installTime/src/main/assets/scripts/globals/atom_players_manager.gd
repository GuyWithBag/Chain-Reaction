extends Node

signal saved_settings(save_data: Dictionary) 
signal loaded_settings(loaded_settings: Dictionary) 

signal resetted
signal finished_getting_atom_players(atom_players: Array[AtomPlayer])

signal only_one_team_remaining(last_remaining_atom_player: AtomPlayer)
signal player_has_been_eliminated(eliminated_atom_player: AtomPlayer, alive_teams: Array[AtomPlayer])
signal only_two_teams_left(atom_player_1: AtomPlayer, atom_player_2: AtomPlayer)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var player_amount: int = 0

var atom_players: Array[AtomPlayer] = [] 

var eliminated_atom_players: Array[AtomPlayer] = []
var previous_atoms_in_play: Array[AtomPlayer] = []
var atom_players_in_play: Array[AtomPlayer] = []

var default_atom_player_colors: Dictionary = {
	"1" : Color.RED, 
	"2" : Color.YELLOW, 
	"3" : Color.BLUE, 
	"4" : Color.GREEN, 
	"5" : Color.PURPLE,  
}

var atom_player_colors: Dictionary = default_atom_player_colors.duplicate() 

func _ready() -> void: 
#	ChainReactionSequenceManager.chain_reaction_sequence_finished.connect(_on_chain_reaction_sequence_finished)
#	AtomSlotsManager.atom_slot_exploded.connect(_on_atom_slot_exploded)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_atom_player_current_total_atoms_changed(_prev_amount: int, _new_amount: int, atom_player: AtomPlayer) -> void: 
	if atom_player.first_atom_has_been_placed == false: 
		return
	detect_which_team_is_eliminated(atom_player)
	
	
func detect_which_team_is_eliminated(atom_player: AtomPlayer) -> void: 
#	await get_tree().create_timer(3, false).timeout
	if AtomPlayerTurnsManager.is_chain_reacting(): 
		await AtomSlotsManager.atom_slot_exploded
	var atom_count: int = get_current_total_atoms_count(atom_player)
	print("AtomPlayersManager: %s: Atom Count: %s" % [atom_player.group_name, atom_count])
	if atom_count <= 0: 
		if (atom_player in atom_players_in_play) == false: 
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
		var player_number: int = amount + 1 
		var team_color: Color
		if player_number > atom_player_colors.size(): 
			team_color = get_random_color() 
		else: 
			team_color = atom_player_colors[str(player_number)]
		var atom_player: AtomPlayer = AtomPlayer.new(player_number, team_color)
		atom_players.append(atom_player)
		atom_players_in_play.append(atom_player)
	finished_getting_atom_players.emit(atom_players_in_play)
	for player in atom_players: 
		player.current_total_atoms_changed.connect(_on_atom_player_current_total_atoms_changed.bind(player))
	AtomPlayerTurnsManager.start_game()


func get_current_total_atoms_count(atom_player: AtomPlayer) -> int: 
	var current_total_atoms: int = 0
	var atom_slots: Array = get_tree().get_nodes_in_group(atom_player.group_name)
	for atom_slot in atom_slots: 
		current_total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
	return current_total_atoms
	
	
#func get_current_total_atoms_count_by_player_number(atom_player_number: int) -> int: 
#	var current_total_atoms: int = 0
#	var atom_slots: Array = get_tree().get_nodes_in_group(str(atom_player_number))
#	for atom_slot in atom_slots: 
#		current_total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
#	return current_total_atoms
	
	
func get_random_color() -> Color: 
	rng.randomize() 
	var r: float = rng.randf_range(0.05, 0.9)
	rng.randomize() 
	var g: float = rng.randf_range(0.05, 0.9)
	rng.randomize() 
	var b: float = rng.randf_range(0.05, 0.9)
	return Color(r, g, b)
	
	
func elimnate_team(atom_player: AtomPlayer) -> void: 
	eliminated_atom_players.append(atom_player)
	atom_players_in_play.erase(atom_player)
	player_has_been_eliminated.emit(atom_player, atom_players_in_play)
	var atom_players_remaining: int = atom_players_in_play.size()
	print("AtomPlayersManager: %s has been eliminated!" % atom_player.group_name)
	print("AtomPlayersManager: Current teams remaining: %s" % atom_players_remaining)
	if atom_players_remaining == 2: 
		only_two_teams_left.emit(atom_players_in_play[0], atom_players_in_play[1])
	if atom_players_remaining == 1: 
		only_one_team_remaining.emit(atom_players_in_play[0])
#	AtomPlayerTurnsManager.next_turn()


# Called from UndoHistorymanager
func apply_undo_changes(turn_data: TurnData) -> void: 
	atom_players_in_play = turn_data.atom_players_in_play


func save_settings() -> Dictionary: 
	var data: Dictionary = {
		"atom_player_colors" : atom_player_colors 
	}
	saved_settings.emit(data) 
	return data


func load_settings(load_data: Dictionary) -> void: 
	var duplicate_data: Dictionary = load_data["atom_player_colors"].duplicate() 
	var load_data_to_colors: Dictionary = {}
	for key in duplicate_data.keys(): 
		var color_name: String = duplicate_data[key] 
		color_name = color_name.trim_prefix("(")
		color_name = color_name.trim_suffix(")") 
		var split: PackedStringArray = color_name.split(", ") 
		var r: float = float(split[0])
		var g: float = float(split[1])
		var b: float = float(split[2])
		var a: float = float(split[3]) 
		load_data_to_colors[key] = Color(r, g, b ,a) 
	atom_player_colors = load_data_to_colors 
	loaded_settings.emit(load_data) 
	
	
