extends LocalManager
class_name PlayersManager

signal saved_settings(save_data: Dictionary) 
signal loaded_settings(loaded_settings: Dictionary) 

signal resetted
signal finished_getting_players(players: Array[Player])

signal only_one_team_remaining(last_remaining_player: Player)
signal player_has_been_eliminated(eliminated_player: Player, alive_teams: Array[Player])
signal only_two_teams_left(player_1: Player, player_2: Player)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var player_amount: int = 0

var players: Array[Player] = [] 

var eliminated_players: Array[Player] = []
var previous_atoms_in_play: Array[Player] = []
var players_in_play: Array[Player] = []

var default_player_colors: Dictionary = {
	"1" : Color.RED, 
	"2" : Color.YELLOW, 
	"3" : Color.BLUE, 
	"4" : Color.GREEN, 
	"5" : Color.PURPLE,  
}

var player_colors: Dictionary = default_player_colors.duplicate() 

func _ready() -> void: 
#	ChainReactionSequenceManager.chain_reaction_sequence_finished.connect(_on_chain_reaction_sequence_finished)
#	managers.atom_slots.atom_slot_exploded.connect(_on_atom_slot_exploded)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_player_current_total_atoms_changed(_prev_amount: int, _new_amount: int, player: Player) -> void: 
	if player.first_atom_has_been_placed == false: 
		return
	detect_which_team_is_eliminated(player)
	
	
func detect_which_team_is_eliminated(player: Player) -> void: 
#	await get_tree().create_timer(3, false).timeout
	if managers.player_turns.is_chain_reacting(): 
		await managers.atom_slots.atom_slot_exploded
	var atom_count: int = get_current_total_atoms_count(player)
	if GameManager.debug: 
		print("PlayersManager: %s: Atom Count: %s" % [player.group_name, atom_count])
	if atom_count <= 0: 
		if (player in players_in_play) == false: 
			return
		elimnate_team(player)


func reset() -> void: 
	players.clear()
	players_in_play.clear()
	resetted.emit()
	
	
# Called by GameStarter
func start(start_data: GameStartData) -> void: 
	player_amount = start_data.player_amount
	for amount in player_amount: 
		var player_number: int = amount + 1 
		var team_color: Color
		if player_number > player_colors.size(): 
			team_color = get_random_color() 
		else: 
			team_color = player_colors[str(player_number)]
		var player: Player = Player.new(player_number, team_color)
		players.append(player)
		players_in_play.append(player)
	finished_getting_players.emit(players_in_play)
	for player in players: 
		player.current_total_atoms_changed.connect(_on_player_current_total_atoms_changed.bind(player))
	GameManager.world.managers.player_turns.start_game()


func get_current_total_atoms_count(player: Player) -> int: 
	var current_total_atoms: int = 0
	var atom_slots: Array = get_tree().get_nodes_in_group(player.group_name)
	for atom_slot in atom_slots: 
		current_total_atoms += (atom_slot as AtomSlot).atom_stack.atom_count
	return current_total_atoms
	
	
#func get_current_total_atoms_count_by_player_number(player_number: int) -> int: 
#	var current_total_atoms: int = 0
#	var atom_slots: Array = get_tree().get_nodes_in_group(str(player_number))
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
	
	
func elimnate_team(player: Player) -> void: 
	eliminated_players.append(player)
	players_in_play.erase(player)
	player_has_been_eliminated.emit(player, players_in_play)
	var players_remaining: int = players_in_play.size()
	if GameManager.debug: 
		print("PlayersManager: %s has been eliminated!" % player.group_name)
		print("PlayersManager: Current teams remaining: %s" % players_remaining)
	if players_remaining == 2: 
		only_two_teams_left.emit(players_in_play[0], players_in_play[1])
	if players_remaining == 1: 
		only_one_team_remaining.emit(players_in_play[0])
	BackgroundAudioManager.play_temporary_sound(load("res://audio/lost1.wav"))
#	managers.player_turns.next_turn()


# Called from UndoHistorymanager
func apply_undo_changes(turn_data: TurnData) -> void: 
	players_in_play = turn_data.players_in_play


func save_settings() -> Dictionary: 
	var data: Dictionary = {
		"player_colors" : player_colors 
	}
	saved_settings.emit(data) 
	return data


func load_settings(load_data: Dictionary) -> void: 
	var duplicate_data: Dictionary = load_data["player_colors"].duplicate() 
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
	player_colors = load_data_to_colors 
	loaded_settings.emit(load_data) 
	
	
