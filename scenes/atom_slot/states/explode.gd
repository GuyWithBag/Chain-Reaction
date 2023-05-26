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
		_affect_rotation_direction(neighbor_atom_slot)
		_atom_stack.add_atom(1, AtomTeamTurnsManager.current_atom_team_in_turn)
		ChainReactionSequenceManager.pop_back_sequences()
	finished_exploding.emit()
	
	
func _affect_rotation_direction(affected_atom_slot: AtomSlot) -> void: 
		var owner_global_pos: Vector2 = state_machine_owner.global_position 
		var neighbor_global_pos: Vector2 = affected_atom_slot.global_position 
		var x_distance: float = neighbor_global_pos.x - owner_global_pos.x
		var y_distance: float = owner_global_pos.y - neighbor_global_pos.y
		var normalized_distance: Vector2 = Vector2(x_distance, y_distance).normalized()
		var affected_rotation_direction: int = 0
		if normalized_distance == Vector2(0, 1) || normalized_distance == Vector2(1, 0): 
			affected_rotation_direction = 1
		elif normalized_distance == Vector2(0, -1) || normalized_distance == Vector2(-1, 0): 
			affected_rotation_direction = -1
		affected_atom_slot.atom_stack.atoms_sprites.rotation_direction = affected_rotation_direction
	
	

