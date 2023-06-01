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


func _on_atom_added(atom_amount_added: int) -> void: 
	reset_undo_count()
	
	
func reset() -> void: 
	clear_history() 


func clear_history() -> void: 
	history.clear()
	history_cleared.emit()


func save_current_data(atom_slot: AtomSlot) -> void: 
	if !is_instance_valid(atom_slot): 
		return
	if GameManager.current_state != GameManager.State.IN_GAME: 
		return
		
	var atom_slot_data: AtomSlotData = AtomSlotData.new(
		atom_slot.atom_stack.atom_count, 
		atom_slot.atom_player
	)
	AtomSlotsManager.atom_slot_saved_data[atom_slot.name] = atom_slot_data
	
	var turn_data: TurnData = create_turn_data()
#	if GameplayManager.just_undoed == true: 
#		add_turn_data(turn_data)
#		GameplayManager.just_undoed = false
#		return 
	await AtomSlotsManager.atom_added
#	for key in turn_data.atom_slots.keys(): 
#		printerr("%s : %s" % [key, turn_data.atom_slots[key].atom_count])
#	if GameplayManager.just_undoed == true: 
#		GameplayManager.just_undoed = false
#		return 
	add_turn_data(turn_data)
	turn_data.show_details()
#	printerr(history[history.size() - 1].atom_slots)
	
	
func create_turn_data() -> TurnData: 
	return TurnData.new(
		AtomSlotsManager.atom_slot_saved_data.duplicate(),  
		AtomPlayersManager.atom_players_in_play.duplicate(), 
		AtomPlayerTurnsManager.turn_index
	)
	
	
func add_turn_data(turn_data: TurnData) -> void: 
	history.append(turn_data)
	turn_data_added.emit(turn_data)
	
	
func pop_back_turn_data() -> TurnData: 
	turn_data_removed.emit() 
	var pop_back: TurnData = history.pop_back() 
	return pop_back


func apply_undo_changes() -> void: 
	# This is undone
	if undo_count > max_undos: 
		print("UndoHistoryManager: You hit the max undos") 
		return
	var turn_data: TurnData = pop_back_turn_data() 
	if !is_instance_valid(turn_data): 
		turn_data = TurnData.new(
			{},  
			AtomPlayersManager.atom_players_in_play.duplicate(), 
			AtomPlayerTurnsManager.turn_index
		)
		for atom_player in AtomPlayersManager.atom_players_in_play: 
			atom_player.reset()
	AtomSlotsManager.apply_undo_changes(turn_data)
	AtomPlayerTurnsManager.apply_undo_changes(turn_data)
	AtomPlayersManager.apply_undo_changes(turn_data)
	for atom_player in AtomPlayersManager.atom_players_in_play: 
		var atom_count: int = AtomPlayersManager.get_current_total_atoms_count(atom_player)
		atom_player.current_total_atoms = atom_count
	undo_count += 1


func reset_undo_count() -> void: 
	undo_count = 0
