extends Node

signal history_cleared()

signal turn_data_removed(turn_data: TurnData)
signal turn_data_added(turn_data: TurnData)

# This is undone 
var max_undos: int = 1
var undo_count: int = 0

var history: Array[TurnData] = [] 


func _ready() -> void: 
	AtomSlotsManager.atom_added.connect(_on_atom_added)


func _on_atom_added(_atom_amount_added: int) -> void: 
	reset_undo_count()
	
	
func reset() -> void: 
	clear_history() 


func clear_history() -> void: 
	history.clear()
	history_cleared.emit()


func save_current_data() -> void: 
	if GameManager.current_state != GameManager.State.IN_GAME: 
		return
	if GameplayManager.game_round == 0: 
		return 
	var turn_data: TurnData = create_turn_data()
#	if GameplayManager.just_undoed == true: 
#		add_turn_data(turn_data)
#		GameplayManager.just_undoed = false
#		return 
#	await AtomSlotsManager.atom_added
#	for key in turn_data.atom_slots.keys(): 
#		printerr("%s : %s" % [key, turn_data.atom_slots[key].atom_count])
#	if GameplayManager.just_undoed == true: 
#		GameplayManager.just_undoed = false
#		return  
#	if GameplayManager.game_round == turn_data.game_round: 
#		return
	add_turn_data(turn_data)
	turn_data.show_details()
#	printerr(history[history.size() - 1].atom_slots)
	
	
func create_turn_data() -> TurnData: 
	return TurnData.new(
		AtomSlotsManager.atom_slots_saved_data.duplicate(),  
		AtomPlayersManager.atom_players_in_play.duplicate(), 
		AtomPlayerTurnsManager.turn_index, 
		GameplayManager.game_round
	)
	
	
func add_turn_data(turn_data: TurnData) -> void: 
	history.append(turn_data)
	turn_data_added.emit(turn_data)


func apply_undo_changes() -> void: 
	# This is undone
	if undo_count > max_undos: 
		print("UndoHistoryManager: You hit the max undos") 
		return
	if GameplayManager.game_round <= 0: 
		printerr("UndoHistoryManager: This is round 0, you cannot undo further. ")
		return
	history.pop_back()
	var turn_data: TurnData = history.pop_back()
	if !is_instance_valid(turn_data): 
		turn_data = TurnData.new(
			{},  
			AtomPlayersManager.atom_players_in_play.duplicate(), 
			AtomPlayerTurnsManager.turn_index, 
			GameplayManager.game_round
		)
		for atom_player in AtomPlayersManager.atom_players_in_play: 
			atom_player.reset()
	if AtomPlayersManager.eliminated_atom_players.size() > 0: 
		var atom_players_in_play: Array[AtomPlayer] = turn_data.atom_players_in_play
		for atom_player in atom_players_in_play: 
			if AtomPlayersManager.atom_players_in_play.has(atom_player): 
				print("You cannot undo once a player has been eliminated. ")
				return
	AtomSlotsManager.apply_undo_changes(turn_data)
	AtomPlayersManager.apply_undo_changes(turn_data)
	AtomPlayerTurnsManager.apply_undo_changes(turn_data)
	for atom_player in AtomPlayersManager.atom_players_in_play: 
		var current_total_atom_count: int = AtomPlayersManager.get_current_total_atoms_count(atom_player)
		if current_total_atom_count <= 0: 
			atom_player.first_atom_has_been_placed = false
		var atom_count: int = current_total_atom_count
		atom_player.current_total_atoms = atom_count
	undo_count += 1 


func reset_undo_count() -> void: 
	undo_count = 0
