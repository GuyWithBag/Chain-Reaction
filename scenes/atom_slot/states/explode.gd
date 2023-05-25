extends AtomSlotBaseState

signal started_exploding
signal finished_exploding

func enter() -> void: 
	super.enter()
	var neighbor_atom_slots: Array[AtomSlot] = atoms_detector.get_slot_in_all_directions()
#	if AtomSlotsManager.is_tilemap_full_of_cells(): 
#		printerr("full")
#		return
	_explode(neighbor_atom_slots)
	state_machine.change_state(empty_state)


func _explode(neighbor_atom_slots: Array[AtomSlot]) -> void: 
	for neighbor_atom_slot in neighbor_atom_slots: 
		ChainReactionSequenceManager.add_sequence(neighbor_atom_slot.sequence) 
	started_exploding.emit()
	await atoms_sprites.explode_animation() 
	for neighbor_atom_slot in neighbor_atom_slots: 
		var _atom_stack: AtomStack = neighbor_atom_slot.atom_stack 
		var previous_atom_team: AtomTeam = AtomTeamTurnsManager.get_previous_atom_team_turn()
		_atom_stack.add_atom(1, AtomTeamTurnsManager.current_atom_team_in_turn)
		ChainReactionSequenceManager.pop_back_sequences()
	finished_exploding.emit()
