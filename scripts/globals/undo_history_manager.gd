extends Node

signal history_resetted()

signal turn_data_removed(turn_data: TurnData)
signal turn_data_added(turn_data: TurnData)

var history: Array[TurnData] = [] 


func reset_history() -> void: 
	history.clear()
	history_resetted.emit()


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
	await AtomSlotsManager.atom_added
	for key in turn_data.atom_slots.keys(): 
		printerr("%s : %s" % [key, turn_data.atom_slots[key].atom_count])
	add_turn_data(turn_data) 
	printerr(history[history.size() - 1].atom_slots)
	
	
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
	var turn_data: TurnData
#	if history.is_empty(): 
#		turn_data = create_turn_data()
#	else: 
	printerr("taken this: ", history)
	turn_data = pop_back_turn_data() 
	printerr("taken this: ", turn_data.atom_slots)
	AtomSlotsManager.apply_undo_changes(turn_data)
	AtomPlayerTurnsManager.apply_undo_changes(turn_data)
	AtomPlayersManager.apply_undo_changes(turn_data)
