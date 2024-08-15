extends LocalManager
class_name UndoHistoryManager

signal saved_settings(save_data: Dictionary) 
signal loaded_settings(loaded_settings: Dictionary) 

signal history_cleared()

signal turn_data_removed(turn_data: TurnData)
signal turn_data_added(turn_data: TurnData)

# This is undone 
var max_undos: int = 1
var undo_count: int = 0

var history: Array[TurnData] = [] 


func _ready() -> void: 
	await owner.ready
	managers.atom_slots.atom_added.connect(_on_atom_added)


func _on_atom_added(_atom_amount_added: int) -> void: 
	reset_undo_count()
	
	
func reset() -> void: 
	clear_history() 


func clear_history() -> void: 
	history.clear()
	history_cleared.emit()


func save_current_data() -> void: 
	if GameManager.is_playing(): 
		return
	if managers.gameplay.game_round == 0: 
		return 
	var turn_data: TurnData = create_turn_data()
#	if managers.gameplay.just_undoed == true: 
#		add_turn_data(turn_data)
#		managers.gameplay.just_undoed = false
#		return 
#	await managers.atom_slots.atom_added
#	for key in turn_data.atom_slots.keys(): 
#		printerr("%s : %s" % [key, turn_data.atom_slots[key].atom_count])
#	if managers.gameplay.just_undoed == true: 
#		managers.gameplay.just_undoed = false
#		return  
#	if managers.gameplay.game_round == turn_data.game_round: 
#		return
	add_turn_data(turn_data)
	if GameManager.debug: 
		turn_data.show_details()
#	printerr(history[history.size() - 1].atom_slots)
	
	
func create_turn_data() -> TurnData: 
	return TurnData.new(
		managers.atom_slots.atom_slots_saved_data.duplicate(),  
		PlayersManager.players_in_play.duplicate(), 
		managers.player_turns.turn_index, 
		managers.gameplay.game_round
	)
	
	
func add_turn_data(turn_data: TurnData) -> void: 
	history.append(turn_data)
	turn_data_added.emit(turn_data)


func apply_undo_changes() -> void: 
	# This is undone
	if undo_count > max_undos: 
		print("UndoHistoryManager: You hit the max undos") 
		return
	if managers.gameplay.game_round <= 0: 
		printerr("UndoHistoryManager: This is round 0, you cannot undo further. ")
		return
#	history.pop_back()
	var turn_data: TurnData = history.pop_back()
	if !is_instance_valid(turn_data): 
		turn_data = TurnData.new(
			{},  
			PlayersManager.players_in_play.duplicate(), 
			managers.player_turns.turn_index, 
			managers.gameplay.game_round
		)
		for player in PlayersManager.players_in_play: 
			player.reset()
	if PlayersManager.eliminated_players.size() > 0: 
		var players_in_play: Array[Player] = turn_data.players_in_play
		for player in players_in_play: 
			if PlayersManager.players_in_play.has(player): 
				print("You cannot undo once a player has been eliminated. ")
				return
	managers.atom_slots.apply_undo_changes(turn_data)
	PlayersManager.apply_undo_changes(turn_data)
	managers.player_turns.apply_undo_changes(turn_data)
	for player in PlayersManager.players_in_play: 
		var current_total_atom_count: int = PlayersManager.get_current_total_atoms_count(player)
		if current_total_atom_count <= 0: 
			player.first_atom_has_been_placed = false
		var atom_count: int = current_total_atom_count
		player.current_total_atoms = atom_count
	undo_count += 1 


func reset_undo_count() -> void: 
	undo_count = 0


func save_settings() -> Dictionary: 
	var data: Dictionary = {
		"max_undos" : max_undos 
	} 
	saved_settings.emit(data)
	return data
	
	
func load_settings(data: Dictionary) -> void: 
	max_undos = data["max_undos"]
	loaded_settings.emit(data) 
	
	
